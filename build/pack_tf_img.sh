#!/bin/bash
echo_log ()
{
    echo "\033[32m$1\033[0m"
}

echo_tip ()
{
    echo "\033[33m$1\033[0m"
}

echo_err ()
{
    echo "\033[31m ERROR: $1\033[0m"
}

# check the environment variables roughly
if [ -z $_TOP_DIR ] ; then
    echo_err "please make sure you have configure the environment variables in ./env.sh correctly！"
    exit
fi

echo_log "gen img size = $_IMG_SIZE MB"
_ROOTFS_SIZE=`gzip -l $_ROOTFS_FILE | sed -n '2p' | awk '{print $2}'`
_ROOTFS_SIZE=`echo "scale=3;$_ROOTFS_SIZE/1024/1024" | bc`
echo_tip "We dont enable overlay here"
_MOD_SIZE=`du $_MOD_FILE --max-depth=0 | cut -f 1`
_MOD_SIZE=`echo "scale=3;$_MOD_SIZE/1024" | bc`
_MIN_SIZE=`echo "scale=3;$_UBOOT_SIZE+$_P1_SIZE+$_ROOTFS_SIZE+$_MOD_SIZE+$_CFG_SIZEKB/1024" | bc` #+$_OVERLAY_SIZE
echo_log  "min img size = $_MIN_SIZE MB"
_FREE_SIZE=`echo "$_IMG_SIZE-$_MIN_SIZE"|bc`
echo_log  "free space=$_FREE_SIZE MB"

rm $_IMG_FILE
if [ ! -e $_IMG_FILE ] ; then
    echo_log  "gen empty img..."
    dd if=/dev/zero of=$_IMG_FILE bs=1M count=$_IMG_SIZE
fi
if [ $? -ne 0 ]
then echo_err  "getting error in creating dd img!"
    exit
fi

_LOOP_DEV=$(sudo losetup -f)
if [ -z $_LOOP_DEV ]
then echo_err  "can not find a loop device!"
    exit
fi

sudo losetup $_LOOP_DEV $_IMG_FILE
if [ $? -ne 0 ]
then echo_err  "dd img --> $_LOOP_DEV error!"
    sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
fi

#############################################
#  			BOOT FROM TF CARD				#
#############################################
if [ "$_BOOT_DEV" = tf ] ; then
    echo_log  "creating partitions for tf image ..."
cat <<EOT |sudo  sfdisk $_IMG_FILE
${_UBOOT_SIZE}M,${_P1_SIZE}M,c
,,L
EOT
    sleep 2
    sudo partx -u $_LOOP_DEV
    sudo mkfs.vfat ${_LOOP_DEV}p1 ||exit
    sudo mkfs.ext4 ${_LOOP_DEV}p2 ||exit
    if [ $? -ne 0 ]
    then echo_err  "error in creating partitions"
        sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
    fi
    
    echo_log  "writing u-boot-sunxi-with-spl to $_LOOP_DEV"
    sudo dd if=$_UBOOT_FILE of=$_LOOP_DEV bs=1024 seek=8
    if [ $? -ne 0 ]
    then echo_err  "writing u-boot error!"
        sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
    fi
    
    sudo sync
    mkdir -p $_P1 >/dev/null 2>&1
    mkdir -p $_P2 > /dev/null 2>&1
    sudo mount ${_LOOP_DEV}p1 $_P1
    sudo mount ${_LOOP_DEV}p2 $_P2
    echo_log  "copy boot and rootfs files..."
    sudo rm -rf  $_P1/* && sudo rm -rf $_P2/*
    #############################################
    # 			TF MAINLINE KERNEL				#
    #############################################
    echo_tip "TF MAINLINE KERNEL"
	sudo cp $_KERNEL_FILE $_P1/zImage &&\
	sudo cp $_DTB_FILE $_P1/ &&\
	sudo cp $_UBOOT_SCR_FILE $_P1/ &&\
	echo_log "p1 done~"
	sudo tar xzvf $_ROOTFS_FILE -C $_P2/ &&\
	echo_log "p2 done~"
	sudo mkdir -p $_P2/lib/modules/${_KERNEL_VER}-f1c100s-wyl1d/ &&\
	if [ ! "$(ls $_MOD_FILE)" = "" ]; then
		sudo cp -r $_MOD_FILE/*  $_P2/lib/modules/${_KERNEL_VER}-f1c100s-wyl1d/
	fi
	echo_log "modules done~"

	if [ $? -ne 0 ]
	then echo_err  "copy files error! "
	    sudo losetup -d $_LOOP_DEV >/dev/null 2>&1
	    sudo umount ${_LOOP_DEV}p1  ${_LOOP_DEV}p2 >/dev/null 2>&1
	    exit
	fi
	echo_log "The tf card image-packing task done~"
    
    sudo sync
    sudo umount $_P1 $_P2  && sudo losetup -d $_LOOP_DEV
    if [ $? -ne 0 ]
    then echo_err  "umount or losetup -d error!!"
        exit
    fi
    
else
    #############################################
    # 			BOOT FROM SPI FLASH				#
    #############################################
    echo_tip  "please using pack_flash_img.sh"
    exit
fi

echo_log  "The $_IMG_FILE has been created successfully!"
echo_tip "gen img size = $_IMG_SIZE MB"
echo_tip "min img size = $_MIN_SIZE MB"
echo_tip "free space = $_FREE_SIZE MB"
exit






