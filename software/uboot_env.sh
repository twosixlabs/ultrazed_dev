#!/bin/bash

export UBOOT_DEFCONFIG=xilinx_zynqmp_zcu102_revB_defconfig

function configuboot() {
	make ${UBOOT_DEFCONFIG}
}

function menuuboot() {
	make menuconfig
}

function makeuboot() {
	make -j16
}

function cleanuboot() {
	make clean
}
