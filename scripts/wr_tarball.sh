#!/bin/bash

# Print help menu
function print_help()
{
   echo -e "Syntax: wr_tarball.sh --tar <TAR>"
   echo -e "-h --help   = Print this menu"
   echo -e "--tar 		= Name of the output tarball"
   exit
}

# Make tarball working directory
function mk_tardir()
{
	mkdir ${TAR_DIR}
	mkdir ${TAR_DIR}/scripts
	mkdir ${TAR_DIR}/software
}

# Copy Boot
function cp_boot()
{
	echo "-----------------------------"
	echo "Copying Boot"
	echo "-----------------------------"
	cp -a ${BOOT_INSTALL_DIR}/ ${TAR_DIR}/software/.
	sync
}

# Copy rootFS
function cp_rootfs()
{
	echo "-----------------------------"
	echo "Copying rootFS"
	echo "-----------------------------"	
	sudo cp -a ${ROOTFS_INSTALL_DIR}/ ${TAR_DIR}/software/.
	sync
}

# Copy install scripts
function cp_scripts()
{
	echo "-----------------------------"
	echo "Copying install scripts"
	echo "-----------------------------"	
	cp -v ./scripts/wr_sdcard.sh ${TAR_DIR}/scripts/.
	cp -v ./scripts/wr_mmc.sh ${TAR_DIR}/scripts/.
	cp -v ./scripts/parseopt.sh ${TAR_DIR}/scripts/.
	sync
}

# Write the tarball
function wr_tarball()
{
	echo "-----------------------------"
	echo "Writing tarball"
	echo "-----------------------------"
	sudo tar -czf ${TAR}.tar.gz ${TAR_DIR}
	sudo rm -fr ${TAR_DIR}
}

# Define variables
BOOT_INSTALL_DIR=./software/boot_part
ROOTFS_INSTALL_DIR=./software/rootfs_part
TAR_DIR=./sd_image

# Parse command line options
options=()
options+=(-h:HELP)
options+=(--help:HELP)
options+=(--tar=:TAR)
source ./scripts/parseopt.sh

if [ "$HELP" == 1 ] 
then
	print_help
	exit
fi

if [ "$TAR" == "" ] 
then
	echo -e "ERROR:  Need to specify tarball name"
	print_help
   	exit
fi

# Generate tarball
mk_tardir
cp_boot
cp_rootfs
cp_scripts
wr_tarball

echo "-----------------------------"
echo "Tarball Write Complete"
echo "-----------------------------"
