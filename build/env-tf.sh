#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source $SCRIPT_DIR/env.sh
#change here to your config
export _BOOT_DEV=tf
export _KERNEL_TYPE=main
export _KERNEL_VER=4.15.0
export _DT_NAME=suniv-f1c100s-licheepi-nano
export _IMG_SIZE=200
export _UBOOT_SIZE=1
export _CFG_SIZEKB=0
export _P1_SIZE=16
export _MOD_FILE=$_MOD_DIR/$_KERNEL_VER-next-20180202-licheepi-nano+

export _UBOOT_FILE=$_UBOOT_DIR/u-boot-$_BOOT_DEV.bin
export _UBOOT_SCR_FILE=$_UBOOT_DIR/boot.scr
export _DTB_NAME=$_DT_NAME.dtb
export _DTB_FILE=$_DTB_DIR/$_DTB_NAME
export _KERNEL_FILE=$_KERNEL_DIR/$_BOOT_DEV-zImage
export _ROOTFS_FILE=$_ROOTFS_DIR/rootfs-$_BOOT_DEV.tar.gz
export _IMG_FILE=$_IMG_DIR/Nano_$_BOOT_DEV.dd
source $SCRIPT_DIR/gen_scr.sh $_BOOT_DEV $_KERNEL_TYPE $_UBOOT_SCR_FILE


