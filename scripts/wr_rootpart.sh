#!/bin/bash

# Copy rootfs
function cp_rootfs()
{
	sudo unsquashfs -f -d ${ROOTFS_INSTALL_DIR} ../software/ubuntu-server-16042-arm64.squashfs
}

# Copy peek/poke application and scripts
function cp_apps()
{
	sudo cp -v ../software/axi_hpm0_rw/axi_hpm0_rw ${ROOTFS_INSTALL_DIR}${USER_DIR}/.
	sudo cp -v config_fpga.sh ${ROOTFS_INSTALL_DIR}${USER_DIR}/.
	sudo cp -v ultrazed.py ${ROOTFS_INSTALL_DIR}/${USER_DIR}/.
	sudo cp -v fpga_mmap.py ${ROOTFS_INSTALL_DIR}/${USER_DIR}/.
}

# Copy FPGA image
function cp_fpgaimg()
{
	sudo cp -v ../software/fpga_image/$FPGA_IMG.bin ${ROOTFS_INSTALL_DIR}/lib/firmware/.
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
# iface eth0 inet dhcp
iface eth0 inet static
   address ${BOARD_IP_ADDR}
   hwaddress ether ${BOARD_MAC_ADDR}
   netmask 255.255.0.0
   gateway 172.20.0.90
   dns-nameserver 172.20.0.90' > ${ROOTFS_INSTALL_DIR}/etc/network/interfaces"
}

# Write /etc/hosts, /etc/hostname
function wr_hostname()
{
	sudo sh -c "echo '127.0.1.1	${BOARD_HOSTNAME}.localdomain	${BOARD_HOSTNAME}' > ${ROOTFS_INSTALL_DIR}/etc/hosts"
	sudo sh -c "echo '${BOARD_HOSTNAME}' > ${ROOTFS_INSTALL_DIR}/etc/hostname"
}

# Write /etc/fstab
function wr_fstab()
{
	sudo sh -c "echo '${SD_DEVICE}p2  /  auto errors=remount-ro  0  1
${SD_DEVICE}p1  /boot auto defaults  0  2' > ${ROOTFS_INSTALL_DIR}/etc/fstab"
}

# Add sources to APT repo list
function wr_repolist()
{
	sudo sh -c "echo '
deb http://ports.ubuntu.com/ubuntu-ports/ xenial main
deb http://ports.ubuntu.com/ubuntu-ports/ xenial universe
deb http://ports.ubuntu.com/ubuntu-ports/ xenial multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-security main
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates universe
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates multiverse' > $ROOTFS_INSTALL_DIR/etc/apt/sources.list"
}

# Define variables
BOARD_NUM=3
BOARD_HOSTNAME=ultrazed${BOARD_NUM}
BOARD_MAC_ADDR=00:0A:35:00:00:0${BOARD_NUM}
BOARD_IP_ADDR=172.20.2.42
ROOTFS_INSTALL_DIR=./rootfs_part
USER_DIR=/home/zynqmp
FPGA_IMG=ultrazed_top
SD_DEVICE=/dev/mmcblk1

# Install and configure rootFS
sudo rm -fr ${ROOTFS_INSTALL_DIR}
mkdir ${ROOTFS_INSTALL_DIR}
cp_rootfs
# cp_modules
cp_apps
cp_fpgaimg
wr_ethinterface
wr_hostname
wr_fstab
wr_repolist
sync

echo "-----------------------------"
echo "rootFS Script Complete"
echo "-----------------------------"
