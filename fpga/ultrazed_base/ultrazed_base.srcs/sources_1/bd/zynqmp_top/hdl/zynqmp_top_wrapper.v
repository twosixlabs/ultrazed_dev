//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.1 (lin64) Build 1846317 Fri Apr 14 18:54:47 MDT 2017
//Date        : Mon Jun  5 08:29:55 2017
//Host        : thoyt-dell7510 running 64-bit Ubuntu 16.04.2 LTS
//Command     : generate_target zynqmp_top_wrapper.bd
//Design      : zynqmp_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zynqmp_top_wrapper
   (axi_ref_clk,
    axi_rst_n,
    led_8bits_tri_o,
    pl_ref_clk_n,
    pl_ref_clk_p,
    test_reg_axi_araddr,
    test_reg_axi_arprot,
    test_reg_axi_arready,
    test_reg_axi_arvalid,
    test_reg_axi_awaddr,
    test_reg_axi_awprot,
    test_reg_axi_awready,
    test_reg_axi_awvalid,
    test_reg_axi_bready,
    test_reg_axi_bresp,
    test_reg_axi_bvalid,
    test_reg_axi_rdata,
    test_reg_axi_rready,
    test_reg_axi_rresp,
    test_reg_axi_rvalid,
    test_reg_axi_wdata,
    test_reg_axi_wready,
    test_reg_axi_wstrb,
    test_reg_axi_wvalid);
  output axi_ref_clk;
  output [0:0]axi_rst_n;
  output [7:0]led_8bits_tri_o;
  input pl_ref_clk_n;
  input pl_ref_clk_p;
  output [5:0]test_reg_axi_araddr;
  output [2:0]test_reg_axi_arprot;
  input test_reg_axi_arready;
  output test_reg_axi_arvalid;
  output [5:0]test_reg_axi_awaddr;
  output [2:0]test_reg_axi_awprot;
  input test_reg_axi_awready;
  output test_reg_axi_awvalid;
  output test_reg_axi_bready;
  input [1:0]test_reg_axi_bresp;
  input test_reg_axi_bvalid;
  input [31:0]test_reg_axi_rdata;
  output test_reg_axi_rready;
  input [1:0]test_reg_axi_rresp;
  input test_reg_axi_rvalid;
  output [31:0]test_reg_axi_wdata;
  input test_reg_axi_wready;
  output [3:0]test_reg_axi_wstrb;
  output test_reg_axi_wvalid;

  wire axi_ref_clk;
  wire [0:0]axi_rst_n;
  wire [7:0]led_8bits_tri_o;
  wire pl_ref_clk_n;
  wire pl_ref_clk_p;
  wire [5:0]test_reg_axi_araddr;
  wire [2:0]test_reg_axi_arprot;
  wire test_reg_axi_arready;
  wire test_reg_axi_arvalid;
  wire [5:0]test_reg_axi_awaddr;
  wire [2:0]test_reg_axi_awprot;
  wire test_reg_axi_awready;
  wire test_reg_axi_awvalid;
  wire test_reg_axi_bready;
  wire [1:0]test_reg_axi_bresp;
  wire test_reg_axi_bvalid;
  wire [31:0]test_reg_axi_rdata;
  wire test_reg_axi_rready;
  wire [1:0]test_reg_axi_rresp;
  wire test_reg_axi_rvalid;
  wire [31:0]test_reg_axi_wdata;
  wire test_reg_axi_wready;
  wire [3:0]test_reg_axi_wstrb;
  wire test_reg_axi_wvalid;

  zynqmp_top zynqmp_top_i
       (.axi_ref_clk(axi_ref_clk),
        .axi_rst_n(axi_rst_n),
        .led_8bits_tri_o(led_8bits_tri_o),
        .pl_ref_clk_n(pl_ref_clk_n),
        .pl_ref_clk_p(pl_ref_clk_p),
        .test_reg_axi_araddr(test_reg_axi_araddr),
        .test_reg_axi_arprot(test_reg_axi_arprot),
        .test_reg_axi_arready(test_reg_axi_arready),
        .test_reg_axi_arvalid(test_reg_axi_arvalid),
        .test_reg_axi_awaddr(test_reg_axi_awaddr),
        .test_reg_axi_awprot(test_reg_axi_awprot),
        .test_reg_axi_awready(test_reg_axi_awready),
        .test_reg_axi_awvalid(test_reg_axi_awvalid),
        .test_reg_axi_bready(test_reg_axi_bready),
        .test_reg_axi_bresp(test_reg_axi_bresp),
        .test_reg_axi_bvalid(test_reg_axi_bvalid),
        .test_reg_axi_rdata(test_reg_axi_rdata),
        .test_reg_axi_rready(test_reg_axi_rready),
        .test_reg_axi_rresp(test_reg_axi_rresp),
        .test_reg_axi_rvalid(test_reg_axi_rvalid),
        .test_reg_axi_wdata(test_reg_axi_wdata),
        .test_reg_axi_wready(test_reg_axi_wready),
        .test_reg_axi_wstrb(test_reg_axi_wstrb),
        .test_reg_axi_wvalid(test_reg_axi_wvalid));
endmodule
