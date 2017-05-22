#!/bin/bash

FPGA_PROJ=ultrazed_base
FPGA_IMG=ultrazed_top

function build_fsbl() {
	cp ../../fpga/$FPGA_PROJ/$FPGA_PROJ.sdk/$FPGA_IMG.hdf .
	hsi -source build_fsbl.tcl
}

function clean_fsbl() {
	rm -fr hsi* psu_init* $FPGA_IMG.hdf $FPGA_IMG.bit build/
}