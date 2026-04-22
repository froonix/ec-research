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
	ectool -w 0x81 -z 0x00
	#modprobe thinkpad_acpi
}

[[ "$EUID" != "0" ]] && error "Missing root privileges!"
command -v ectool &>/dev/null || error "ectool not found!"

# TODO: --full option for unfiltered page 0x00?
# ...

# TODO: Confirmation prompt?
# ...

# TODO: mktemp?
# ...

sysfs=()
sysfs+=(/sys/class/dmi/id/bios_*)
sysfs+=(/sys/class/dmi/id/board_{name,vendor})
sysfs+=(/sys/class/dmi/id/product_{family,name})
sysfs+=(/sys/class/power_supply/*/*)

status "Gathering sysfs data: ${#sysfs[@]} file(s)"
grep -aH . -- "${sysfs[@]}" 2>/dev/null >"sysfs.txt"
status

trap cleanup EXIT
rmmod thinkpad_acpi battery
for page in {79..0}
do
	[[ "$page" -gt 0 ]] && filter="^(80|a0):" || filter="."
	hex=$(printf '0x%02x' "$page")
	filename="$hex.txt"

	status "Next EC RAM page: $hex"
	ectool -w 0x81 -z "$hex" >"$filename"
	ectool -d | grep -Ei -- "$filter" >>"$filename" \
	&& status "EC RAM page $hex dumped."
done
cleanup
trap - EXIT

# TODO: Create TAR file?
# ...

# TODO: Delete tmpdir!
# ...
