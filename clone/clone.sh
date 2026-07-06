#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run with sudo/root privileges." >&2
    exit 1
fi

read -p "Set hostname after clone " hn

echo "########## Running clone to nvme with new hostname ${hn} ##########"

rpi-clone nvme0n1 -s "${hn}"