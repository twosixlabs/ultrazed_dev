#!/bin/bash

# Print help menu
function print_help()
{
   echo -e "Syntax:  wr_sdcard.sh --dev <SD Card Device>"
   echo -e "--help   = Print this menu"
   echo -e "--part   = Partition SD Card"
   echo -e "--mmc    = Copy the rootFS/Boot partitions to /root"
   echo -e "--dev    = SD Card Device"
   exit
}

# Partition the SD card
function partition_sdcard()
{
	echo "-----------------------------"
	echo "Partitioning the SD Card"
	echo "-----------------------------"
	sudo sh -c 'sfdisk '${SD_DEV}' <<-__EOF__
1M,100M,0xE,*
,,,-
__EOF__'
}

# Format the SD card
function format_sdcard()
{
	echo "-----------------------------"
	echo "Formatting the SD Card"
	echo "-----------------------------"	
	sudo mkfs.vfat -F 32 -n BOOT ${SD_DEV}1
	sudo mkfs.ext4 -L rootfs ${SD_DEV}2
}

# Copy rootFS
function cp_rootfs()
{
	echo "-----------------------------"
	echo "Copying rootFS Partition"
	echo "-----------------------------"	
	mkdir ${ROOTFS_MOUNT_DIR}
	sudo mount ${SD_DEV}2 ${ROOTFS_MOUNT_DIR}
	sudo cp -a ${ROOTFS_INSTALL_DIR}/. ${ROOTFS_MOUNT_DIR}/
	sync
	sudo umount ${ROOTFS_MOUNT_DIR}
	rm -fr ${ROOTFS_MOUNT_DIR}
}

# Copy uBoot
function cp_boot()
{
	echo "-----------------------------"
	echo "Copying Boot Partition"
	echo "-----------------------------"	
	mkdir ${BOOT_MOUNT_DIR}
	sudo mount ${SD_DEV}1 ${BOOT_MOUNT_DIR}
	sudo cp -rv ${BOOT_INSTALL_DIR}/. ${BOOT_MOUNT_DIR}/
	sync
	sudo umount ${BOOT_MOUNT_DIR}
	rm -fr ${BOOT_MOUNT_DIR}
}

# Copy rootFS and boot partition to the root directory
# Used to image the eMMC after booting from SD card
function cp_emmc()
{
	echo "-----------------------------"
	echo "Copying partitions for eMMC"
	echo "-----------------------------"	
	mkdir ${ROOTFS_MOUNT_DIR}
	sudo mount ${SD_DEV}2 ${ROOTFS_MOUNT_DIR}
	echo "Root file system..."
	sudo cp -a ${ROOTFS_INSTALL_DIR} ${ROOT_DIR}/.
	sync
	echo "Boot partition..."
	sudo cp -a ${BOOT_INSTALL_DIR} ${ROOT_DIR}/.
	sync
	sudo cp ./scripts/wr_mmc.sh ${ROOT_DIR}/.
	sudo cp ./scripts/parseopt.sh ${ROOT_DIR}/.
	sync
	sudo umount ${ROOTFS_MOUNT_DIR}
	rm -fr ${ROOTFS_MOUNT_DIR}
}

# Define variables
BOOT_MOUNT_DIR=./boot_install
BOOT_INSTALL_DIR=./software/boot_part
ROOTFS_MOUNT_DIR=./rootfs_install
ROOTFS_INSTALL_DIR=./software/rootfs_part
ROOT_DIR=${ROOTFS_MOUNT_DIR}/root

# Parse command line options
options=()
options+=(--help:HELP)
options+=(--part:SD_PART)
options+=(--dev=:SD_DEV)
options+=(--mmc:MMC_COPY)
source ./scripts/parseopt.sh

if [ "$HELP" == 1 ] 
then
	print_help
	exit
fi

if [ "$SD_DEV" == "" ] 
then
	echo -e "ERROR:  Need to specify SD Card device"
	echo -e "Syntax: wr_sdcard.sh --dev <SD Card Device>\n"
   	lsblk
   	exit
fi

# Check to see if SD_DEV is mounted
if mount | grep $SD_DEV > /dev/null
then
	echo -e "ERROR: Need to un-mount $SD_DEV\n"
	lsblk
	exit
fi

# Partition a new SD card
if [ "$SD_PART" == 1 ] 
then
   partition_sdcard
fi

# Check to see if SD_DEV is an SD card reader 
# Append "p" to "/dev/mmcblkX" --> "/dev/mmcblkXpN"
# USB SD card readers mount as "/dev/sdX" --> "/dev/sdXN"
if echo $SD_DEV | grep mmcblk > /dev/null
then
	SD_DEV="${SD_DEV}p"
fi

# Write a new SD card
format_sdcard
cp_rootfs
cp_boot

# Copy the rootFS and boot partitions to the /root directory for flashing to eMMC 
if [ "$MMC_COPY" == 1 ] 
then
   cp_emmc
fi

echo "-----------------------------"
echo "SD Card Write Complete"
echo "-----------------------------"
