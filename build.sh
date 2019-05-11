#!/bin/bash
rm -rf /out
make kernelversion
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
mkdir -p out
echo
echo "Cleaning OUT"
echo
make O=out clean
echo
echo "Running mrproper"
echo
make O=out mrproper
echo
echo "Making config file"
echo
make O=out ARCH=arm64 noodle_beryllium_defconfig
echo
echo "Compiling the source"
echo
PATH="/home/ktk/kernel/toolchain/custom-clang/bin:/home/ktk/kernel/toolchain/gcc9/bin:${PATH}"
make -j4 O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=~/kernel/toolchain/gcc-32/bin/arm-linux-androideabi-
if [ -f out/arch/arm64/boot/Image.gz-dtb ]; then
      echo
      echo "The image is compiled"
      echo
      mv out/arch/arm64/boot/Image.gz-dtb ~/kernel/anykernel2/Image.gz-dtb
      rm -rf out
      cd ~/kernel/anykernel2
      echo
      echo "Creating a Flashable ZIP"
      echo
      zip -r9 noodle_kernel-$(date +"%Y-%m-%d").zip *
      rm -rf Image.gz-dtb
      echo
      echo "Movied to ZIPs Folder "
      echo
      mv noodle_kernel-$(date +"%Y-%m-%d").zip ~/kernel/ZIPs
else
      echo
  	  echo "Kernel did not compile, please check for errors!!"
  	  echo
fi
rm -rf /out
