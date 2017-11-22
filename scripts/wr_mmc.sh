#!/bin/bash

# Print help menu
function print_help()
{
   echo -e "Syntax: wr_mmc.sh --dev <eMMC Device>"
   echo -e "-h --help   = Print this menu"
   echo -e "-p --part 	= Partition eMMC"
   echo -e "--dev 		= eMMC Device"
   exit
}

# Partition the eMMC
function partition_mmc()
{
	echo "-----------------------------"
	echo "Partitioning the eMMC"
	echo "-----------------------------"
	sudo sh -c 'sfdisk '${SD_DEV}' <<-__EOF__
1M,100M,0xE,*
,,,-
__EOF__'
}

# Format the eMMC
function format_mmc()
{
	echo "-----------------------------"
	echo "Formatting the eMMC"
	echo "-----------------------------"	
	sudo mkfs.vfat -F 32 -n BOOT ${SD_DEV}1
	sudo mkfs.ext4 -L rootfs ${SD_DEV}2
}

# Write /etc/fstab
function wr_fstab()
{
	sudo sh -c "echo '${SD_DEV}2  /  auto errors=remount-ro  0  1
${SD_DEV}1  /boot auto defaults  0  2
${NFS_SERVER} ${NFS_MNT_DIR} nfs rsize=8192,wsize=8192,timeo=14,intr,rw,tcp,user' > ${ROOTFS_MOUNT_DIR}/etc/fstab"
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
	wr_fstab
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

# Define variables
BOOT_MOUNT_DIR=./boot_install
BOOT_INSTALL_DIR=./boot_part
ROOTFS_MOUNT_DIR=./rootfs_install
ROOTFS_INSTALL_DIR=./rootfs_part
NFS_SERVER=172.20.0.170:/mnt/INFRASTOR1/BOSTITCH
NFS_MNT_DIR=/mnt/bostitch

# Parse command line options
options=()
options+=(-h:HELP)
options+=(--help:HELP)
options+=(--part:SD_PART)
options+=(--dev=:SD_DEV)

. parseopt.sh

if [ "$HELP" == 1 ] 
then
	print_help
	exit
fi

if [ "$SD_DEV" == "" ] 
then
	echo -e "ERROR:  Need to specify eMMC device"
	echo -e "Syntax: wr_mmc.sh --dev <eMMC Device>\n"
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

# Partition the eMMC
if [ "$SD_PART" == 1 ] 
then
   partition_mmc
fi

# Append "p" to "/dev/mmcblkX" --> "/dev/mmcblkXpN"
SD_DEV="${SD_DEV}p"

# Write the eMMC
format_mmc
cp_rootfs
cp_boot

echo "-----------------------------"
echo "eMMC Write Complete"
echo "-----------------------------"
