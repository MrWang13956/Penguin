#/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

if [ "$_BOOT_DEV" = tf ]; then  #tf
(
cat << EOF
setenv bootargs console=tty0 console=ttyS0,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw 
load mmc 0:1 0x80C00000 $_DTB_NAME
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
EOF
) > boot.cmd		

else  #spi
	echo "spi flash"

fi

mkimage -C none -A arm -T script -d boot.cmd $_UBOOT_SCR_FILE
