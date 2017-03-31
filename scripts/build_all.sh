#!/bin/bash

# Print help menu
function print_help()
{
   echo -e "Syntax: build_all.sh"
   echo -e "-h --help   = Print this menu"
   echo -e "-c --clean  = Clean everything"
   exit
}

# Setup envrionment
function env_setup()
{
	cd ..
	source env_setup.sh
}

# Clean
function clean_all()
{
	echo "-----------------------------"
	echo "    Cleaning Everthing...    "
	echo "-----------------------------"	
	# FPGA
	cd fpga/ultrazed_base
	clean_fpga
	cd ../..
	# PMU
	cd software/pmu
	clean_pmu
	# FSBL
	cd ../fsbl
	clean_fsbl
	# ATF
	cd ../arm-trusted-firmware
	make clean
	# DTC
	cd ../dtc
	make clean
	# uBoot
	cd ../u-boot-xlnx
	cleanuboot
	# Kernel
	cd ../linux-xlnx
	cleankernel
	# Device tree
	cd ../device_tree
	rm -fr system.dt*
	# Peek/Poke
	cd ../axi_hpm0_rw
	make clean
	# Boot image
	cd ../boot_image
	clean_bootimg
	cd ../..
}

# Build
function build_all()
{
	echo "-----------------------------"
	echo "    Building Everthing...    "
	echo "-----------------------------"	
	# FPGA
	cd fpga/ultrazed_base
	build_fpga
	cd ../..
	# PMU
	cd software/pmu
	build_pmu
	# FSBL
	cd ../fsbl
	build_fsbl
	# ATF
	cd ../arm-trusted-firmware
	make PLAT=zynqmp RESET_TO_BL31=1
	# DTC
	cd ../dtc
	make
	# uBoot
	cd ../u-boot-xlnx
	cd arch/arm/dts
	if [ ! -e zynqmp-zcu102.dts.orig ]
	then 
		patch -f zynqmp-zcu102.dts ../../../../patches/zynqmp-zcu102.patch
	fi
	cd ../../../
	configuboot
	makeuboot
	# Kernel
	cd ../linux-xlnx
	configkernel
	makekernel
	makemodules
	# Device tree
	cd ../device_tree
	./build_dtb.sh zynqmp-zcu102-revB_xilinx-v2016.4-sdsoc.dts
	# Peek/Poke
	cd ../axi_hpm0_rw
	make
	# Boot image
	cd ../boot_image
	build_bootimg
	cd ../..
}

# Parse command line options
options=()
options+=(-h:HELP)
options+=(--help:HELP)
options+=(-c:CLEAN)
options+=(--clean:CLEAN)

. parseopt.sh

if [ "$HELP" == 1 ] 
then
	print_help
	exit
fi

# Setup envrionment
env_setup

if [ "$CLEAN" == 1 ] 
then
	# Clean everything
	clean_all
	echo "-----------------------------"
	echo "       Clean Complete        "
	echo "-----------------------------"	
else
	# Build everything
	build_all	
	echo "-----------------------------"
	echo "       Build Complete        "
	echo "-----------------------------"	
fi
