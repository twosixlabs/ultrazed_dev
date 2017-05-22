#!/bin/bash

FPGA_PROJ=ultrazed_base
FPGA_IMG=ultrazed_top

# Create the petalinux project
function create_petalinux() {
	rm -fr petalinux_build
	petalinux-create --type project --template zynqMP --name petalinux_build
}

# Import project from Vivado
function import_petalinux() {
	petalinux-config --get-hw-description=../../fpga/$FPGA_PROJ/$FPGA_PROJ.sdk/
}

# Clean the petalinux workspace
function clean_petalinux() {
	petalinux-build --execute cleanall
	petalinux-build --execute mrproper
	rm -fr BOOT.BIN *.elf components/
}

# Build kernel, uBoot and ATF with petalinux
function build_petalinux() {
	petalinux-build --component kernel
	petalinux-build --component u-boot
	petalinux-build --component arm-trusted-firmware
}
