#!/bin/bash

# Check to see that the FPGA image is in '/lib/firmware'
function chk_fpga_img {
	if [ ! -e /lib/firmware/$FPGA_BIN ]
	then
		echo -e "ERROR: Need to copy ${FPGA_BIN} to /lib/firmware directory"
		exit
	fi
}

# Configure the FPGA
function config_fpga() {
	echo -e "Configuring FPGA with ${FPGA_BIN}"
	echo ${FPGA_BIN} > /sys/class/fpga_manager/fpga0/firmware
}

# Dislay configuration status
function fpga_state() {
	FPGA_STATE="$(cat /sys/class/fpga_manager/fpga0/state)"
	echo -e "FPGA State: ${FPGA_STATE}"
	if [ "$FPGA_STATE" == "operating" ]
	then
		echo -e "FPGA configuration success!"
	else
		echo -e "ERROR: FPGA configuration failed!"
	fi
}

FPGA_BIN=ultrazed_base.bin

# Configure the FPGA
chk_fpga_img
config_fpga
fpga_state
