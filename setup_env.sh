#!/bin/bash

#获取当前脚本的绝对路径
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export PATH=$PATH:$SCRIPT_DIR/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi/bin

source $SCRIPT_DIR/build/env-tf.sh
