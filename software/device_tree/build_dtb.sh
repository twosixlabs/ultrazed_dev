#!/bin/bash

# DTS to DTB
function dts_to_dtb()
{
	dtc -I dts -O dtb -o ${DTB_FILE} ${DTS_FILE}
}

# DTB to DTS
function dtb_to_dts()
{
	dtc -I dtb -O dts -o ${DTS_FILE} ${DTB_FILE}
}

DTS_FILE=system.dts
DTB_FILE=system.dtb

if [ "$1" == "" ] 
then
	echo -e "ERROR: Specify DTS file"
   	exit
else
	# Copy original
	cp $1 $DTS_FILE
	# Build DTB
	dts_to_dtb
fi