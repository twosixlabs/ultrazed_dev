#!/bin/bash

HERE=$(pwd)
FPGA_PROJ=ultrazed_base

VIVADO_INSTALL_PATH=~/bin/xilinx_full/Vivado/2017.1
PETALINUX_INSTALL_PATH=~/bin/petalinux_20171

# Setup environment variables
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export SWT_GTK3=0
export PATH=$HERE/software/dtc:$PATH

# Setup SW environment
source $PETALINUX_INSTALL_PATH/settings.sh
source software/petalinux.sh
source software/boot_image/build_boot_image.sh
source software/fpga_image/build_fpga_image.sh
source software/fsbl/build_fsbl.sh
source software/pmu/build_pmu.sh

# Setup HW environment
source fpga/$FPGA_PROJ/build_fpga.sh
source $VIVADO_INSTALL_PATH/settings64.sh
