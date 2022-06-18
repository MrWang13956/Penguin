#/bin/bash

# 将烧录好完整镜像的sd卡擦去uboot,并在p1分区放入当前路径下生成的boot.scr,
# 就可以使用usb加载固件了

echo "清除sd卡uboot"
echo "sudo dd if=zero_1k.bin of=/dev/device bs=1024 seek=8"

echo "制作boot.scr"
echo "mkimage -C none -A arm -T script -d boot.cmd boot.scr"


echo "查看芯片是否进入fel模式"
sunxi-fel ver

echo "加载固件"
sunxi-fel -p uboot u-boot-tf.bin write 0x80008000 tf-zImage write 0x80C00000 suniv-f1c100s-penguin.dtb
