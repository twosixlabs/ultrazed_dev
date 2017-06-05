/* ZynqMP PS Top Level */
module ps_wrapper (
   input             i_pl_ref_clk_p,      // I1  - I/O Carrier PL Reference Clock
   input             i_pl_ref_clk_n,      // I1  -
   output            o_axi_ref_clk,       // O1  - AXI Reference Clock
   output            o_axi_rst_n,         // O1  - 
   output [ 7:0]     o_ps_leds,           // O8  - I/O Carrier LEDs
   axi4_lite.Master  b_test_reg_axi       // Bxx - Test Register/control interface  
);      

/* Constants */

/* Interfaces */

/* REG/WIRE declarations */

/* ZynqMP Top Level - PS Interfaces + AXI Address Decode */                                                
zynqmp_top_wrapper zynqmp_top (   
   // PL Reference Clock
   .pl_ref_clk_n           ( i_pl_ref_clk_n           ), // I1  -
   .pl_ref_clk_p           ( i_pl_ref_clk_p           ), // I1  -
   // AXI Reference Clock/Reset
   .axi_ref_clk            ( o_axi_ref_clk            ), // O1  - 
   .axi_rst_n              ( o_axi_rst_n              ), // O1  -   
   // Test Register AXI-Lite Interface
   .test_reg_axi_araddr    ( b_test_reg_axi.araddr    ),
   .test_reg_axi_arprot    ( b_test_reg_axi.arprot    ),
   .test_reg_axi_arready   ( b_test_reg_axi.arready   ),
   .test_reg_axi_arvalid   ( b_test_reg_axi.arvalid   ),
   .test_reg_axi_awaddr    ( b_test_reg_axi.awaddr    ),
   .test_reg_axi_awprot    ( b_test_reg_axi.awprot    ),
   .test_reg_axi_awready   ( b_test_reg_axi.awready   ),
   .test_reg_axi_awvalid   ( b_test_reg_axi.awvalid   ),
   .test_reg_axi_bready    ( b_test_reg_axi.bready    ),
   .test_reg_axi_bresp     ( b_test_reg_axi.bresp     ),
   .test_reg_axi_bvalid    ( b_test_reg_axi.bvalid    ),
   .test_reg_axi_rdata     ( b_test_reg_axi.rdata     ),
   .test_reg_axi_rready    ( b_test_reg_axi.rready    ),
   .test_reg_axi_rresp     ( b_test_reg_axi.rresp     ),
   .test_reg_axi_rvalid    ( b_test_reg_axi.rvalid    ),
   .test_reg_axi_wdata     ( b_test_reg_axi.wdata     ),
   .test_reg_axi_wready    ( b_test_reg_axi.wready    ),
   .test_reg_axi_wstrb     ( b_test_reg_axi.wstrb     ),
   .test_reg_axi_wvalid    ( b_test_reg_axi.wvalid    ),   
   // LEDs
   .led_8bits_tri_o        ( o_ps_leds                )  // O8  -
); 

endmodule
