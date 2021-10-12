#!/bin/bash

echo $1

if [ ! -f "$1.ova" ]; then
    echo File $1.ova does not exist.
    exit
fi

if [ ! -d "$1" ]; then
    mkdir -v $1
fi

cd $1

rm -v $1.*

tar -xvf ../$1.ova

echo Verifying hashes...
sha256sum -c $1.mf

echo Making qcow2 image from vmdk...
qemu-img convert -f vmdk $1-disk1.vmdk -O qcow2 $1-disk1.qcow2
qemu-img convert -f vmdk $1-disk2.vmdk -O qcow2 $1-disk2.qcow2

rm -v $1-disk1.vmdk
rm -v $1-disk2.vmdk

echo Copying to xen...
scp $1-disk1.qcow2 xen:~/cnmaestro
scp $1-disk2.qcow2 xen:~/cnmaestro

echo Done!
