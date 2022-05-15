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

echo "\nbuild has been cleaned up successfully\n"

