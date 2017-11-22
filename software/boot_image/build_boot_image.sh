#!/bin/bash

function cp_bootimg() {
	cp -v ../petalinux_build/images/linux/zynqmp_fsbl.elf .
	cp -v ../petalinux_build/images/linux/pmufw.elf .
	cp -v ../petalinux_build/images/linux/bl31.elf .
	cp -v ../petalinux_build/images/linux/u-boot.elf .
}

function clean_bootimg() {
	rm -fr BOOT.bin *.elf *.bit
}

function build_bootimg() {
	clean_bootimg
	cp_bootimg
	bootgen -image boot.bif -arch zynqmp -o BOOT.bin -w on 
}
