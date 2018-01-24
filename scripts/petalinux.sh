#!/bin/bash

# Increase the 'max_user_watches' setting to fix the petalinux build error
function fix_petalinux() {
	echo -e "Need SUDO for Petalinux error: 'sysctl -n -w fs.inotify.max_user_watches=65536'"
	sudo sysctl -n -w fs.inotify.max_user_watches=65536 > /dev/null
}

# Disable webtalk cause it ALWAYS fails anyway
function disable_webtalk_petalinux() {
	petalinux-util --webtalk off
}

# Create the petalinux project
function create_petalinux() {
	rm -fr ${PETA_PROJ}
	petalinux-create --type project --template zynqmp --name ${PETA_PROJ}
}

# Import project from Vivado
function import_petalinux() {
	petalinux-config --project ./software/${PETA_PROJ} --get-hw-description=./fpga/$FPGA_PROJ/$FPGA_PROJ.sdk/
}

# Configure the Kernel build
function config_petalinux_kernel() {
	petalinux-config --project ./software/${PETA_PROJ} --component kernel
}

# Configure the u-Boot build
function config_petalinux_uboot() {
	petalinux-config --project ./software/${PETA_PROJ} --component u-boot
}
