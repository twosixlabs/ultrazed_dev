#!/bin/bash

# Copy preconfigured root file system image
function cp_rootfs()
{
	sudo unsquashfs -f -d ${ROOTFS_INSTALL_DIR} ./${ROOTFS_IMAGE}
}

# Copy FPGA image
function cp_fpga_image()
{
	sudo cp -v ../fpga/${FPGA_PROJ}/*.bin ${ROOTFS_INSTALL_DIR}/lib/firmware/${FPGA_BIN}
}

# Write /etc/network/interfaces
function wr_ethinterface()
{
	sudo sh -c "echo '# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback
  
auto eth0
iface eth0 inet dhcp
# iface eth0 inet static
#    address ${BOARD_IP_ADDR}
#    netmask 255.255.0.0
#    gateway 172.20.0.90
#    dns-nameserver 172.20.0.90' > ${ROOTFS_INSTALL_DIR}/etc/network/interfaces"
}

# Write /etc/hosts, /etc/hostname
function wr_hostname()
{
	sudo sh -c "echo '127.0.0.1	localhost
127.0.1.1	${BOARD_HOSTNAME}.localdomain	${BOARD_HOSTNAME}

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters' > ${ROOTFS_INSTALL_DIR}/etc/hosts"

	sudo sh -c "echo '${BOARD_HOSTNAME}' > ${ROOTFS_INSTALL_DIR}/etc/hostname"
}

# Write /etc/fstab
function wr_fstab()
{
	sudo sh -c "echo '/dev/mmcblk0p2  /  auto errors=remount-ro  0  1
/dev/mmcblk0p1  /boot auto defaults  0  2' > ${ROOTFS_INSTALL_DIR}/etc/fstab"
}

# Copy python applications
function cp_apps()
{
	sudo cp -v ./ultrazed.py ${ROOTFS_INSTALL_DIR}/${USER_DIR}/.
	sudo cp -v ./mmio.py ${ROOTFS_INSTALL_DIR}/${USER_DIR}/.
}

# Define variables
BOARD_HOSTNAME=ultrazed
BOARD_IP_ADDR=172.20.2.28
ROOTFS_INSTALL_DIR=./rootfs_part
ROOTFS_IMAGE=ubuntu-server-16043-arm64.squashfs
USER_DIR=/home/zynqmp

echo "-----------------------------------------"
echo "Installing Root File System Partition... "
echo "-----------------------------------------"
sudo rm -fr ${ROOTFS_INSTALL_DIR}
mkdir ${ROOTFS_INSTALL_DIR}
cp_rootfs
cp_fpga_image
wr_ethinterface
wr_hostname
wr_fstab
cp_apps
sync
