#!/bin/bash

if [ ! -f "$1-disk1.qcow2" ]; then
    echo File $1-disk1.qcow2 does not exist.
    exit
fi
if [ ! -f "$1-disk2.qcow2" ]; then
    echo File $1-disk2.qcow2 does not exist.
    exit
fi

sudo xl destroy cnmaestro
sleep 5

sudo modprobe nbd max_part=63

sudo qemu-nbd -r -n -c /dev/nbd0 $1-disk1.qcow2
sudo qemu-nbd -r -n -c /dev/nbd1 $1-disk2.qcow2

sudo dd if=/dev/nbd0 of=/dev/xen/cnmaestro-disk1 bs=1M
sudo dd if=/dev/nbd1 of=/dev/xen/cnmaestro-disk2 bs=1M

sudo qemu-nbd -v -d /dev/nbd0
sudo qemu-nbd -v -d /dev/nbd1

sudo xl create /etc/xen/auto/cnmaestro.cfg

echo "vnc://xen0:5900"

