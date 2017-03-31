#!/bin/bash

function build_pmu() {
	cp ../../fpga/ultrazed_base/ultrazed_base.sdk/ultrazed_top.hdf .
	hsi -source build_pmu.tcl
}

function clean_pmu() {
	rm -fr hsi* psu_init* ultrazed_top.hdf build/
}
