/* UltraZed Top Level */
module ultrazed_top (
   // I/O Carrier PL Reference Clock
   input            i_pl_ref_clk_p,
   input            i_pl_ref_clk_n,
   // I/O Carrier LEDs
   output [ 7:0]    o_ps_leds        
);      

/* Constants */
localparam SYSCLK_FREQ_MHZ = 100;
// Configure FPGA Heartbeat in Hz
localparam FPGA_HB_FREQ_HZ = 4;
localparam SYSCLK_FREQ_HZ  = SYSCLK_FREQ_MHZ * 1000000;
localparam FPGA_HB_TIMER   = SYSCLK_FREQ_HZ / ( 2 * FPGA_HB_FREQ_HZ );

/* Interfaces */
axi4_lite #(.A_WIDTH(6),.D_WIDTH(32)) test_reg_axi ();     // Test AXI Register Interface

/* REG/WIRE declarations */
(* mark_debug = "false" *) logic axi_ref_clk, axi_rst_n;
(* mark_debug = "false" *) logic fpga_hb;
(* mark_debug = "false" *) logic [31:0] fpga_hb_cnt;

/* Continuous Assignments */
assign o_ps_leds[0]  = fpga_hb;

/* FPGA Hearbeat */ 
always @ ( posedge axi_ref_clk or negedge axi_rst_n ) begin
   if ( ~axi_rst_n ) begin
      fpga_hb_cnt <= 'd0;
      fpga_hb     <= 1'b0;
   end else begin
      if ( fpga_hb_cnt == FPGA_HB_TIMER ) begin
         fpga_hb_cnt <='d0;
         fpga_hb     <= ~fpga_hb;
      end else begin
         fpga_hb_cnt <= fpga_hb_cnt + 'd1;
      end
   end
end

/* ZynqMP Top Level - PS Interfaces + AXI Address Decode */                                                
zynqmp_top_wrapper zynq_ps_axi_decode(   
   // PL Reference Clock
   .pl_ref_clk_n           ( i_pl_ref_clk_n        ), // I1  -
   .pl_ref_clk_p           ( i_pl_ref_clk_p        ), // I1  -
   // AXI Reference Clock/Reset
   .axi_ref_clk            ( axi_ref_clk           ), // O1  - 
   .axi_rst_n              ( axi_rst_n             ), // O1  -   
   // Test Register AXI-Lite Interface
   .test_reg_axi_araddr    ( test_reg_axi.araddr   ),
   .test_reg_axi_arprot    ( test_reg_axi.arprot   ),
   .test_reg_axi_arready   ( test_reg_axi.arready  ),
   .test_reg_axi_arvalid   ( test_reg_axi.arvalid  ),
   .test_reg_axi_awaddr    ( test_reg_axi.awaddr   ),
   .test_reg_axi_awprot    ( test_reg_axi.awprot   ),
   .test_reg_axi_awready   ( test_reg_axi.awready  ),
   .test_reg_axi_awvalid   ( test_reg_axi.awvalid  ),
   .test_reg_axi_bready    ( test_reg_axi.bready   ),
   .test_reg_axi_bresp     ( test_reg_axi.bresp    ),
   .test_reg_axi_bvalid    ( test_reg_axi.bvalid   ),
   .test_reg_axi_rdata     ( test_reg_axi.rdata    ),
   .test_reg_axi_rready    ( test_reg_axi.rready   ),
   .test_reg_axi_rresp     ( test_reg_axi.rresp    ),
   .test_reg_axi_rvalid    ( test_reg_axi.rvalid   ),
   .test_reg_axi_wdata     ( test_reg_axi.wdata    ),
   .test_reg_axi_wready    ( test_reg_axi.wready   ),
   .test_reg_axi_wstrb     ( test_reg_axi.wstrb    ),
   .test_reg_axi_wvalid    ( test_reg_axi.wvalid   ),   
   // LEDs
   .led_8bits_tri_o        ( o_ps_leds[7:1]        )  // O8  -
);

/* Test Register Interface */
test_regs #( 
   .D_WIDTH ($size( test_reg_axi.wdata  )),
   .A_WIDTH ($size( test_reg_axi.awaddr )))
test_registers (
   .i_clk               ( axi_ref_clk           ), // I1  - System Clock
   .i_rst_n             ( axi_rst_n             ), // I1  - Active-low system clock synchronized reset
   .b_reg_axi           ( test_reg_axi.Slave    ), // Bxx - Register/control interface
   .i_version_major     ( 16'hAAAA              ), // I16 - Version Major
   .i_version_minor     ( 16'h5555              ), // I16 - Version Minor  
   .o_debug_test_reg    (                       )  // Oxx - Debug/test register
); 

endmodule
