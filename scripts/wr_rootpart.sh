#!/bin/bash

# Copy rootfs
function cp_rootfs()
{
	sudo unsquashfs -f -d ${ROOTFS_INSTALL_DIR} ../software/ubuntu-server-16042-arm64.squashfs
}

# Update kernel modules
function cp_modules()
{
	sudo rm -fr ${ROOTFS_INSTALL_DIR}/lib/modules/
	sudo cp -rv ${INSTALL_MOD_PATH}/lib ${ROOTFS_INSTALL_DIR}/.
}

# Copy peek/poke and test python library
function cp_apps()
{
	sudo cp -v ../software/axi_hpm0_rw/axi_hpm0_rw ${ROOTFS_INSTALL_DIR}/usr/local/bin/.
	sudo cp -v ultrazed.py ${ROOTFS_INSTALL_DIR}/home/zynqmp/.
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
	sudo sh -c "echo '/dev/mmcblk0p2  /  auto errors=remount-ro  0  1
/dev/mmcblk0p1  /boot auto defaults  0  2' > ${ROOTFS_INSTALL_DIR}/etc/fstab"
}

# Define variables
BOARD_HOSTNAME=ultrazed
BOARD_IP_ADDR=172.20.2.30
ROOTFS_INSTALL_DIR=./rootfs_part
INSTALL_MOD_PATH=/tmp/xilinx_socfpga_kernel/deploy/modules

# Install and configure rootFS
sudo rm -fr ${ROOTFS_INSTALL_DIR}
mkdir ${ROOTFS_INSTALL_DIR}
cp_rootfs
cp_modules
cp_apps
wr_ethinterface
wr_hostname
wr_fstab
sync

echo "-----------------------------"
echo "rootFS Script Complete"
echo "-----------------------------"
