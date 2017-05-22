#!/bin/bash

FPGA_PROJ=ultrazed_base
FPGA_IMG=ultrazed_top

function build_pmu() {
	cp ../../fpga/$FPGA_PROJ/$FPGA_PROJ.sdk/$FPGA_IMG.hdf .
	hsi -source build_pmu.tcl
}

function clean_pmu() {
	rm -fr hsi* psu_init* $FPGA_IMG.hdf $FPGA_IMG.bit build/
}