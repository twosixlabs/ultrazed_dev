#!/bin/bash

# Copy boot image
function cp_boot_image()
{
	cp -v ../software/boot_image/BOOT.bin ${BOOT_INSTALL_DIR}/.
}

# Copy kernel image
function cp_kernel()
{
	cp -v ../software/petalinux_build/images/linux/Image ${BOOT_INSTALL_DIR}/.
}

# Copy device tree binaries
function cp_dtb()
{
	cp -v ../software/device_tree/system.dtb ${BOOT_INSTALL_DIR}/.
}

# Copy uEnv.txt
function cp_uenv()
{
	cp -v ../software/uEnv.txt ${BOOT_INSTALL_DIR}/.
}

# Copy FPGA image
function cp_fpgaimg()
{
	cp -v ../fpga/$FPGA_PROJ/$FPGA_PROJ.runs/impl_1/$FPGA_IMG.bit ${BOOT_INSTALL_DIR}/.
}

# Define variables
BOOT_INSTALL_DIR=./boot_part
FPGA_PROJ=ultrazed_base
FPGA_IMG=ultrazed_top

# Install boot partitions
rm -fr ${BOOT_INSTALL_DIR}
mkdir ${BOOT_INSTALL_DIR}
cp_boot_image
cp_kernel
cp_dtb
cp_uenv
cp_fpgaimg

echo "-----------------------------"
echo "Boot Script Complete"
echo "-----------------------------"
