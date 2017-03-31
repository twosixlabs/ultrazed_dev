#!/bin/bash

function cp_fpgabit() {
	cp -v ../../fpga/ultrazed_base/ultrazed_base.runs/impl_1/ultrazed_top.bit .
}

function clean_fpgaimg() {
	rm -fr *.bit *.bin
}

function build_fpgaimg() {
	clean_fpgaimg
	cp_fpgabit
	bootgen -image fpga.bif -arch zynqmp -process_bitstream bin -w on 
	mv ultrazed_top.bit.bin ultrazed_top.bin
}
