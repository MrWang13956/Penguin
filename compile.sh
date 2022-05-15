#/bin/bash


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOCAL_UBOOT="$SCRIPT_DIR/../u-boot"
LOCAL_LINUX="$SCRIPT_DIR/../linux-5.4.193"
LOCAL_BUILDROOT="$SCRIPT_DIR/../buildroot"
BUILD="$SCRIPT_DIR/build"
OUTPUT="$BUILD/output"

source $SCRIPT_DIR/setup_env.sh

if [ $1 = "-h" ]
then
	echo "-m make"
	echo "-c clean"
	
elif [ $1 = "-c" ]
then
	if [ $2 = "uboot" ]
	then
		cd $LOCAL_UBOOT
		./uboot_compile.sh -c
	elif [ $2 = "linux" ]
	then
		cd $LOCAL_LINUX
		./linux_compile.sh -c 
	elif [ $2 = "buildroot" ]
	then
		cd $LOCAL_BUILDROOT
		./build_compile.sh -c 
	else
		echo "all"
	fi

elif [ $1 = "-m" ]
then
	if [ $2 = "uboot" ]
	then
		cd $LOCAL_UBOOT
		./uboot_compile.sh -m &&\
		cp u-boot-sunxi-with-spl.bin $OUTPUT/uboot/u-boot-tf.bin
	elif [ $2 = "linux" ]
	then
		cd $LOCAL_LINUX
		./linux_compile.sh -m linux
		cp arch/arm/boot/zImage $OUTPUT/kernel/tf-zImage
		cp arch/arm/boot/dts/suniv-f1c100s-wyl1d.dtb $OUTPUT/kernel/dtb/suniv-f1c100s-wyl1d.dtb
	elif [ $2 = "dtbs" ]
	then
		cd $LOCAL_LINUX
		./linux_compile.sh -m dtbs
		cp arch/arm/boot/dts/suniv-f1c100s-wyl1d.dtb $OUTPUT/kernel/dtb/suniv-f1c100s-wyl1d.dtb
	elif [ $2 = "buildroot" ]
	then
		cd $LOCAL_BUILDROOT
		./build_compile.sh -m 
		cp buildroot-2022.02/output/images/rootfs.tar.gz $OUTPUT/rootfs/rootfs-tf.tar.gz
	else
		echo "all"
	fi

elif [ $1 = "package" ]
then
	cd $BUILD
	./pack_tf_img.sh
	echo -e "\ndd image"
	echo "sudo dd if=$BUILD/output/image/WYL1D_tf.dd of=/dev/device && sync"

	
elif [ $1 = "clean" ]
then
	cd $BUILD
	./clean_img.sh
	
else
	echo "Please enter -h for help!"

fi
