#!/usr/bin/python3

import subprocess
import sys
import time

BRAM_BASE = '0x0'
LED_BASE  = '0x10000'

# Generic peek/poke
def peek(addr,echo):
   	p = subprocess.check_output(["axi_hpm0_rw", "-r", addr])
   	if echo == 1:
   		print (str(p,'utf-8').strip('\n'))
   	else:
   		return (str(p,'utf-8').strip('\n'))

def poke(addr,value,mask):
   	p = subprocess.call(["axi_hpm0_rw", "-w", addr, "-v", value, "-m", mask])

# Writes to the LED DPIO
def led_wr(value_int):
	arg_str = str(hex(value_int).lstrip('0x'))
	msk_str = '0xFF'	
	poke(LED_BASE,arg_str,msk_str)

# Count 0 - 255 in binary using the GPIO LEDs
def led_count():
	loop_cnt = 0
	while loop_cnt < 256:
		led_wr(loop_cnt)
		loop_cnt = loop_cnt + 1
		time.sleep(0.5)

# Write to the base address in BRAM
def bram_wr(arg_str):
	msk_str = '0xFFFFFFFF'
	poke(BRAM_BASE,arg_str,msk_str)

# Read from the base address in BRAM
def bram_rd():
	peek(BRAM_BASE,1)	
