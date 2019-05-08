#!/bin/bash
rm -rf /out
make kernelversion
export ARCH=arm64 && export SUBARCH=arm64
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
mkdir -p out
make O=out clean
make O=out mrproper
make O=out ARCH=arm64 noodle_beryllium_defconfig
PATH="~/kernel/toolchain/custom-clang/bin:~/kernel/toolchain/gcc9/bin:${PATH}" \
make -j$(nproc --all) O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-gnu-

mv out/arch/arm64/boot/Image.gz-dtb ~/kernel/anykernel/Image.gz-dtb
rm -rf out
cd ~/kernel/anykernel
zip -r noodle_kernel-$(date +"%Y-%m-%d").zip *
rm -rf Image.gz-dtb
