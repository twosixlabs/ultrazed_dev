#!/bin/bash

function cp_bootimg() {
	cp -v ../fsbl/build/executable.elf ultrazed_fsbl.elf
	cp -v ../../fpga/ultrazed_base/ultrazed_base.runs/impl_1/ultrazed_top.bit .
	cp -v ../pmu/build/executable.elf ultrazed_pmu.elf
	cp -v ../arm-trusted-firmware/build/zynqmp/release/bl31/bl31.elf .
	cp -v ../u-boot-xlnx/u-boot.elf .
}

function clean_bootimg() {
	rm -fr BOOT.bin *.elf *.bit
}

function build_bootimg() {
	clean_bootimg
	cp_bootimg
	bootgen -image boot.bif -arch zynqmp -o BOOT.bin -w on 
}
