#!/bin/sh

set -e

failure() { echo "$1";  exit 1; }

fwinfo() {
	awk "/$1/ { print \$2 }" /etc/fw-info | tr -d '",'
}

if [ -f /etc/fw-info ]; then
	plat=$(fwinfo platform)
	inst_type=$(fwinfo install_type)

	if [ -n "$plat" ] && [ "$plat" != "xil" ]; then
		failure "Wrong firmware update file, target platform is xil"
	fi

	if [ -n "$inst_type" ] && [ "$inst_type" != "nand" ]; then
		failure "Wrong firmware update file, target installation type is nand"
	fi
fi

if [ -f fw.md5 ]; then
	echo "Verifying md5 checksums"
    md5sum -s -c fw.md5 > /dev/null 2>&1
fi

if [ -e uramdisk.image.gz ]; then
	echo "Updating uramdisk.image.gz"
	flash_erase /dev/mtd1 0x0 0x100 >/dev/null 2>&1
	nandwrite -p -s 0x0 /dev/mtd1 uramdisk.image.gz > /dev/null 2>&1
fi

sync