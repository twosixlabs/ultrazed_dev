#!/bin/bash

FPGA_PROJ=ultrazed_base
FPGA_IMG=ultrazed_top
BOARD_IP=172.20.2.42

function cp_fpgabit() {
	cp -v ../../fpga/$FPGA_PROJ/$FPGA_PROJ.runs/impl_1/$FPGA_IMG.bit .
}

function clean_fpgaimg() {
	rm -fr *.bit *.bin
}

function build_fpgaimg() {
	clean_fpgaimg
	cp_fpgabit
	bootgen -image fpga.bif -arch zynqmp -process_bitstream bin -w on 
	mv $FPGA_IMG.bit.bin $FPGA_IMG.bin
}

# Build a new BIN, SCP the BIN and BIT onto the board
# Accept an IP address argument or default to BOARD_IP
# Add the boards ssh keys with 'ssh-copy-id root@BOARD_IP'
function update_fpgaimg() {
	build_fpgaimg
	if [ "$1" == "" ] 
	then
		echo -e "Updating FPGA image on: ${BOARD_IP}"
		scp $FPGA_IMG.bin root@${BOARD_IP}:/lib/firmware/.
		scp $FPGA_IMG.bit root@${BOARD_IP}:/boot/.
	else
		echo -e "Updating FPGA image on: $1"
		scp $FPGA_IMG.bin root@$1:/lib/firmware/.
		scp $FPGA_IMG.bit root@$1:/boot/.
	fi
}
