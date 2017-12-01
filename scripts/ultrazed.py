#!/usr/bin/python3

import time
import numpy as np
import os
from mmio import MMIO

# Board/FPGA Constants
LED_GPIO_ADDR  = 0x0
AXI_HPM0_ADDR_L = 0x80000000
AXI_HPM0_ADDR_H = 0x800FFFFF
TEST_BRAM_ADDR = 0x2000
TEST_BRAM_DEPTH = 1024

# Generic peek/poke
# Read/Write registers in the specified address space
# Lenth = 32-bit word length
# Write value = numpy uint32 array, integer or list
def peek(addr,length=1,echo=0):
	# Add the HPM0 base address to requested address
	addr = AXI_HPM0_ADDR_L + addr
   	if AXI_HPM0_ADDR_L <= addr <= AXI_HPM0_ADDR_H: 
   		byte_len = length << 2
   		# Map the memory buffer, print or return the register/buffer
   		mem = MMIO(addr,byte_len)
   		if echo == 1:
   			mem.read(0x0,byte_len)
   			print mem.hexdump()
		else:  		 
			return mem.read(0x0,byte_len)
   	else:
   		print ("ERROR: Address is outside FPGA memory space")

def poke(addr,value,mask=None):
	# Add the HPM0 base address to requested address
	base_addr = AXI_HPM0_ADDR_L + addr
   	if AXI_HPM0_ADDR_L <= base_addr <= AXI_HPM0_ADDR_H: 
   		# Accept int, list, or np.array types
   		if type(value) is int:
   			word_len = 1
   			byte_len = 4
   		else:
   			word_len = len(value) 
   			byte_len = len(value) << 2
   		# Map the memory buffer
   		mem = MMIO(base_addr,byte_len)
   		# If a mask is needed, apply the mask to the entire buffer, or just write the buffer
   		# When word_len = 1 mem.read returns an integer, cast to a np.array and mask/value to a list
   		if mask is not None: 
   			if type(mask) is int: mask = [mask]
   			if type(value) is int: value = [value]
			rdbuf = np.uint32([mem.read(0x0,byte_len)])
   			wrbuf = np.zeros(word_len,dtype=np.uint32)
   			for i in range(0,word_len):	
   				wrbuf[i] = (rdbuf[0] & ~mask[i]) | (value[i] & mask[i])
   				addr += 4
   			# Write the buffer
   			mem.write(base_addr,wrbuf)
   		else:
   			# Write the value
   			mem.write(base_addr,value)
   	else:
   		print ("ERROR: Address is outside FPGA memory space")

# Write 4K, record the time elapsed and print throughput
# Throughput = 4Kbyte / time elapsed
def wr_benchmark(echo=True):
	wr_value = [i for i in range(0,TEST_BRAM_DEPTH)]
	wr_buf = np.uint32(wr_value)
	t1 = time.time()
	poke(TEST_BRAM_ADDR,wr_buf)
	t2 = time.time()
	bps = (TEST_BRAM_DEPTH * 32) / (t2 - t1)
	Mbps = bps / 1000000
	MBps = Mbps / 8
	if echo:
		print "Time elapsed: %.5fs" % (t2 - t1)
		print "Mb/s: %.3f" % Mbps
		print "MB/s: %.3f" % MBps
	else:
		return [Mbps,MBps]

# Read 4K, record the time elapsed and print throughput
# Throughput = 4Kbyte / time elapsed
def rd_benchmark(echo=True):
	t1 = time.time()
	rd_value = peek(TEST_BRAM_ADDR,TEST_BRAM_DEPTH)
	t2 = time.time()
	bps = (TEST_BRAM_DEPTH * 32) / (t2 - t1)
	Mbps = bps / 1000000
	MBps = Mbps / 8
	if echo:
		print "Time elapsed: %.5fs" % (t2 - t1)
		print "Mb/s: %.3f" % Mbps
		print "MB/s: %.3f" % MBps
	else:
		return [Mbps,MBps]

# Run a rd/wr benchmark of the FPGA fabbric
# Read and write 4K blocks of memory for 'loop_cnt' iterations, print results
def fpga_benchmark(loop_cnt):
	print "Running WR Benchmark..."
	wr_results = [0.0,0.0]
	for i in range(0,loop_cnt):
		wr_results = np.add(wr_results,wr_benchmark(False))
	print "Running RD Benchmark..."
	rd_results = [0.0,0.0]
	for i in range(0,loop_cnt):
		rd_results = np.add(rd_results,rd_benchmark(False))
	print "WR Throughput:"
	print "Mb/s: %.3f" % (wr_results[0] / float(loop_cnt))
	print "MB/s: %.3f" % (wr_results[1] / float(loop_cnt))
	print "RD Throughput:"
	print "Mb/s: %.3f" % (rd_results[0] / float(loop_cnt))
	print "MB/s: %.3f" % (rd_results[1] / float(loop_cnt))

# Configure the FPGA
def config_fpga():
	ret_val = os.system("echo ultrazed_top.bin > /sys/class/fpga_manager/fpga0/firmware ")
	if ret_val == 0: print "FPGA configuration success!"
	else: print "FPGA configuration FAILED!"

# Writes to the LED DPIO
def led_wr(value):
	arg = value
	msk = 0xFF
	poke(LED_GPIO_ADDR,arg,msk)

# Count 0 - 255 in binary using the GPIO LEDs
def led_count():
	loop_cnt = 0
	while loop_cnt < 256:
		led_wr(loop_cnt)
		loop_cnt = loop_cnt + 1
		time.sleep(0.050)