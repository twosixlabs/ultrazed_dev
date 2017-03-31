#!/bin/bash

# Copy boot image
function cp_boot_image()
{
	cp -v ../software/boot_image/BOOT.bin ${BOOT_INSTALL_DIR}/.
}

# Copy kernel image
function cp_kernel()
{
	cp -v $BUILD_KERNEL_DIR/arch/arm64/boot/Image ${BOOT_INSTALL_DIR}/.
}

# Copy device tree binaries
function cp_dtb()
{
	cp -v ../software/device_tree/system.dtb ${BOOT_INSTALL_DIR}/.
	# cp -v $INSTALL_DTBS_PATH/xilinx/zynqmp-zcu102.dtb system.dtb
}

# Define variables
BOOT_INSTALL_DIR=./boot_part
BUILD_KERNEL_DIR=/tmp/xilinx_socfpga_kernel
INSTALL_DTBS_PATH=${BUILD_KERNEL_DIR}/deploy/dtbs

# Install boot partitions
rm -fr ${BOOT_INSTALL_DIR}
mkdir ${BOOT_INSTALL_DIR}
cp_boot_image
cp_kernel
cp_dtb

echo "-----------------------------"
echo "Boot Script Complete"
echo "-----------------------------"
