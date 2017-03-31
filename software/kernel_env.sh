#!/bin/bash

export KERNEL_DEFCONFIG=xilinx_zynqmp_defconfig
export BUILD_KERNEL_DIR=/tmp/xilinx_socfpga_kernel
export INSTALL_MOD_PATH=${BUILD_KERNEL_DIR}/deploy/modules
export INSTALL_DTBS_PATH=${BUILD_KERNEL_DIR}/deploy/dtbs

function configkernel() {
	mkdir -p ${BUILD_KERNEL_DIR}
	mkdir -p ${INSTALL_DTBS_PATH}
	mkdir -p ${INSTALL_MOD_PATH}
	make O=${BUILD_KERNEL_DIR} ${KERNEL_DEFCONFIG}
}

function menukernel() {
	make O=${BUILD_KERNEL_DIR} menuconfig
}

function makekernel() {
	make O=${BUILD_KERNEL_DIR} -j16
}

function cleankernel() {
	make mrproper
	rm -fr ${BUILD_KERNEL_DIR}
}

function makemodules() {
	make O=${BUILD_KERNEL_DIR} -j16 modules
	make O=${BUILD_KERNEL_DIR} -j16 modules_install
}

function makedtbs() {
	make O=${BUILD_KERNEL_DIR} -j16 dtbs
	make O=${BUILD_KERNEL_DIR} -j16 dtbs_install
}
