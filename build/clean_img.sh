#!/bin/sh

clean_file ()
{
	if [ -f $1 ]; then
    	rm $1
	fi
}


clean_file $_UBOOT_FILE
clean_file $_UBOOT_SCR_FILE
clean_file $_DTB_FILE
clean_file $_KERNEL_FILE
clean_file $_ROOTFS_FILE
clean_file $_IMG_FILE
rm -rf $_MOD_FILE/*



clean_file debug/u-boot-$_BOOT_DEV.bin
clean_file debug/$_BOOT_DEV-zImage
clean_file debug/$_DTB_NAME
clean_file debug/boot.scr

echo "\nbuild has been cleaned up successfully\n"

