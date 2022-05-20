setenv bootargs console=tty1 console=ttyS1,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw
bootz 0x80008000 - 0x80C00000
