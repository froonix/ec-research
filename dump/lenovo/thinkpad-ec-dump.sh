#!/bin/bash
shopt -s failglob
set -o pipefail
LANG=C

# EC RAM pages to dump.
# Should always end with 0!
pages=({79..0})

# Kernel modules to (un)load.
# $imod is filled automatically!
rmod=(tp_smapi thinkpad_acpi battery)
imod=()

# sysfs files to collect.
sysfs=()
sysfs+=(/sys/class/dmi/id/bios_*)
sysfs+=(/sys/class/dmi/id/board_{name,vendor})
sysfs+=(/sys/class/dmi/id/product_{family,name})
sysfs+=(/sys/class/power_supply/*/*)

# Add tp_smapi sysfs files only if they exist.
smapi=/sys/devices/platform/smapi
[[ -e "$smapi" ]] && sysfs+=("$smapi"/*/*)

# Poor man's ThinkPad detection for safety.
tpdetect="/sys/class/dmi/id/product_family"
tpstring="ThinkPad"

# Filename for final TAR archive. Will be saved (as root) in current working directory!
tarfile="$(basename "$0" | sed -r 's/\.[^.]+$//').$(date --utc +'%Y%m%d-%H%M%S').tgz"

prefix()
{
	sed 's/^/  - /'
}

indent()
{
	sed 's/^/    /'
}

printList()
{
	for line in "$@"
	do
		status "$line" | prefix | indent
	done
}

status()
{
	printf '%s\n' "$@"
}

error()
{
	printf '%s: %s\n' "$(basename "$0")" "$*" >&2
	exit 1
}

cleanup()
{
	local kmod
	local i

	status "Resetting EC RAM page"
	switchPage 0x00 | grep -v '^$'

	status
	status "Loading ${#imod[@]} kernel module(s)"
	for ((i=${#imod[@]}-1; i>=0; i--))
	do
		kmod="${imod[i]}"
		status "$kmod" | prefix
		modprobe -v "$kmod" 2>&1 | indent
	done

	if [[ -n "$tmpdir" && -d "$tmpdir" ]]
	then
		status
		status "Deleting temporary directory: $tmpdir"
		rm -rf "$tmpdir"
	fi
}

int2hex()
{
	printf '0x%02x' "$1"
}

switchPage()
{
	ectool -w 0x81 -z "$1"
}

getDump()
{
	filename="$tmpdir/$(int2hex "$1").txt"
	[[ -f "$filename" ]] || return 1

	grep -i -- "^$2:" "$filename"  | getValues
}

getLine()
{
	getDump 0 "$1"
}

getPage()
{
	getDump "$1" a0
}

getValues()
{
	cut -d ' ' -f 2-
}

getFields()
{
	cut -d ' ' -f "$1"
}

littleEndian()
{
	local l
	local h
	local v

	#shellcheck disable=SC2162
	read l h
	v=$(( (0x$h<<8) | 0x$l ))
	printf '%d' "$v"
}

getByte()
{
	local v
	local b

	v=$(cat)
	b=$((0x$v & 0xff))
	printf '%d' "$b"
}

getBit()
{
	local s
	local v
	local b

	v=$(cat)
	s=$(printf '%d' "$1")
	b=$(( (0x$v>>s) & 0x1 ))
	printf '%d' "$b"
}

decodeDate()
{
	local v
	local y
	local m
	local d

	v=$(littleEndian)
	y=$(( (v>>9) + 1980 ))
	m=$(( (v>>5) & 0xf ))
	d=$(( v & 0x1f ))

	printf "%04d-%02d-%02d\n" "$y" "$m" "$d"
}

getString()
{
	sed -r 's/00( ..)*//' | xxd -r -p
}

[[ "$EUID" == "0" ]] || error "Missing root privileges!"
command -v ectool &>/dev/null || error "ectool not found!"
grep -qF -- "$tpstring" "$tpdetect" || error "Not a ThinkPad!"
[[ "${#sysfs[@]}" -gt 0 ]] || error "Empty sysfs list!"
command -v xxd &>/dev/null || error "xxd not found!"

status "$(basename "$0") by Christian Schrötter <cs@fnx.li>"
status "Original source: https://github.com/froonix/ec-research"
status
status "Summary of the actions this script performs:"
status
status "   1) Creating a temporary directory."
status "   2) Collecting various files from sysfs:"
printList "${sysfs[@]}"
status "   3) Unloading various conflicting kernel modules:"
printList "${rmod[@]}"
status "   4) Dumping ${#pages[@]} page(s) directly from EC RAM with ectool."
status "      This step will write to the EC RAM to switch pages!"
status "   5) Creating a TAR file in current directory:"
printList "$(pwd)/$tarfile"
status "   6) Decoding some battery details."
status "   7) Cleaning up:"
printList "Resetting EC RAM page to 0x00."
printList "Loading all removed kernel modules."
printList "Deleting temporary directory."
status
status "Important: It cannot be completely ruled out that the EC RAM may"
status "temporarily contain individual keystrokes, among other things,"
status "since the EC in ThinkPads also controls some keyboard-related"
status "functions. Don't proceed if this could be a problem."
status
status "DON'T EXECUTE THIS SCRIPT ON A THINKPAD WITHOUT AN H8-COMPATIBLE EC!"
status "EVEN ON COMPATIBLE THINKPADS YOUR DEVICE OR OPERATING SYSTEM MIGHT CRASH."
status "SAVE IMPORTANT DOCUMENTS AND CLOSE ALL APPLICATIONS BEFORE CONTINUING..."
status
read -rp "Do you really want to continue? [y/N] " reply
[[ "${reply^^}" == "Y" ]] || error "Aborting."
status

tmpdir=
trap cleanup EXIT
tmpdir=$(mktemp -d ) || { trap - EXIT; error "mktemp failed!"; }
status "Temporary directory created: $tmpdir"
status

status "Gathering sysfs data: ${#sysfs[@]} file(s)"
grep -aH . -- "${sysfs[@]}" 2>/dev/null >"$tmpdir/sysfs.txt"
status

status "Unloading ${#rmod[@]} kernel module(s)"
for kmod in "${rmod[@]}"
do
	# TODO: Check if module is loaded!
	# ...

	status "$kmod" | prefix
	rmmod -v "$kmod" 2>&1 | indent && imod+=("$kmod")
done
status

status "Dumping EC RAM: ${#pages[@]} page(s)"
for page in "${pages[@]}"
do
	[[ "$page" -gt 0 ]] \
	&& filter="^(80|a0):" \
	|| filter="."

	hex=$(int2hex "$page")
	filename="$tmpdir/$hex.txt"

	status "Next EC RAM page: $hex" | prefix
	switchPage "$hex" >"$filename"
	ectool -d | grep -Ei -- "$filter" >>"$filename"
	realPage=$(getDump "$page" 80 | getFields 2 | getByte)

	if [[ "$realPage" == "$page" ]]
	then
		status "EC RAM page $hex dumped." | indent
	else
		status "FAILED! Got page $(int2hex "$realPage") instead." | indent
		rm -f "$filename"
	fi
done
status

status "Creating TAR file"
tar -cva -C "$tmpdir" -f "$tarfile" . 2>&1 | prefix \
|| error "Could not create TAR file!"
status

status "Battery details:"
for id in {0,1}
do
	bat="BAT$id"
	offset=$((id * 16))
	status "$bat:" | prefix

	# Battery present? (Bit 7 in register 0x38/0x39)
	bpr=$(getLine 30 | getFields "$((9 + id))" | getBit 7)
	[[ "$bpr" == "1" ]] || { printList "Not available"; continue; }

	printList "Manufacturer:     $(getPage "$((offset + 5))" | getString)"
	printList "Model (FRU):      $(getPage "$((offset + 6))" | getString)"
	printList "Barcode (S/N):    $(getPage "$((offset + 7))" | getString)"
	printList "Manufacture Date: $(getPage "$((offset + 2))" | getFields 9-10 | decodeDate)"
	printList "First Use Date:   $(getPage "$((offset + 2))" | getFields 5-6 | decodeDate)"
	printList "Chemistry:        $(getPage "$((offset + 4))" | getString)"
	printList "Cycle Count:      $(getPage "$((offset + 1))" | getFields 5-6 | littleEndian)"
done
status

cleanup
trap - EXIT

status
status "TAR location: $(pwd)"
status "TAR filename: $tarfile"
status
status "Please send that TAR file to the developer. Thanks! :-)"
status "Feel free to review the contents of the file beforehand."
exit 0
