#!/bin/sh

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# need edit as your env
export _TOP_DIR=$SCRIPT_DIR/output

# don't need edit
export _KERNEL_DIR=$_TOP_DIR/kernel
export _MOD_DIR=$_TOP_DIR/lib/modules
export _SCRIPT_DIR=$_TOP_DIR/script
export _UBOOT_DIR=$_TOP_DIR/uboot
export _DTB_DIR=$_TOP_DIR/kernel/dtb
export _ROOTFS_DIR=$_TOP_DIR/rootfs
export _IMG_DIR=$_TOP_DIR/image
export _P1=$_TOP_DIR/p1
export _P2=$_TOP_DIR/p2
	
