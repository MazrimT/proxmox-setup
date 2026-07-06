#!/bin/bash
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run with sudo/root privileges." >&2
    exit 1
fi

[ -z "$1" ] && echo "need new hostname as input param" && exit 1

hn=$1

echo "########## Running clone to nvme with new hostname ${hn} ##########"

rpi-clone nvme0n1 -s "${hn}" -u -v