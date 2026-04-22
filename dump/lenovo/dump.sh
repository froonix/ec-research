#!/bin/bash
#shellcheck disable=SC2024

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
	#shellcheck disable=SC2317
	sudo ectool -w 0x81 -z 0x00
}

#[[ "$EUID" != "0" ]] && error "Missing root privileges!"
#command -v ectool &>/dev/null || error "ectool not found!"
sudo bash -c 'command -v ectool' &>/dev/null || error "ectool not found!"

sysfs=()
sysfs+=(/sys/class/dmi/id/bios_*)
sysfs+=(/sys/class/dmi/id/board_{name,vendor})
sysfs+=(/sys/class/dmi/id/product_{family,name})
sysfs+=(/sys/class/power_supply/*/*)

status "Gathering sysfs data: ${#sysfs[@]} file(s)"
grep -aH . -- "${sysfs[@]}" 2>/dev/null >"sysfs.txt"
status

trap cleanup EXIT
for page in {31..0}
do
	[[ "$page" -gt 0 ]] && filter="^a0:" || filter="."
	hex=$(printf '0x%02x' "$page")
	filename="$hex.txt"

	status "Next EC RAM page: $hex"
	sudo ectool -w 0x81 -z "$hex" >"$filename"
	sudo ectool -d | grep -i -- "$filter" >>"$filename" \
	&& status "EC RAM page $hex dumped."
done
