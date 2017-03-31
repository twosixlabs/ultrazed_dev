//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Mon Mar 27 09:58:20 2017
//Host        : thoyt-dell7510 running 64-bit Ubuntu 16.04.2 LTS
//Command     : generate_target zynqmp_top_wrapper.bd
//Design      : zynqmp_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zynqmp_top_wrapper
   (led_8bits_tri_o);
  output [7:0]led_8bits_tri_o;

  wire [7:0]led_8bits_tri_o;

  zynqmp_top zynqmp_top_i
       (.led_8bits_tri_o(led_8bits_tri_o));
endmodule
