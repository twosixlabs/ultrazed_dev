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

/* ZynqMP PS Wrapper */                                                
ps_wrapper ps_axi_decode (   
   .i_pl_ref_clk_n   ( i_pl_ref_clk_n        ), // I1  - PL Reference Clock
   .i_pl_ref_clk_p   ( i_pl_ref_clk_p        ), // I1  -
   .o_axi_ref_clk    ( axi_ref_clk           ), // O1  - AXI Reference Clock/Reset
   .o_axi_rst_n      ( axi_rst_n             ), // O1  -   
   .o_ps_leds        ( o_ps_leds[7:1]        ), // O8  - LEDs
   .b_test_reg_axi   ( test_reg_axi.Master   )  // Bxx - Test Register/control interface 
);

/* Test Register Interface */
test_regs #( 
   .D_WIDTH ($size( test_reg_axi.wdata  )),
   .A_WIDTH ($size( test_reg_axi.awaddr )))
test_registers (
   .i_clk               ( axi_ref_clk           ), // I1  - System Clock
   .i_rst_n             ( axi_rst_n             ), // I1  - Active-low system clock synchronized reset
   .b_reg_axi           ( test_reg_axi.Slave    ), // Bxx - Register/control interface
   .i_version_major     ( 16'h8765              ), // I16 - Version Major
   .i_version_minor     ( 16'h4321              ), // I16 - Version Minor  
   .o_en                (                       ), // O1  - Enable
   .o_en_pls            (                       ), // O1  - 
   .o_reg1              (                       ), // O1  - Control register 1
   .o_reg2              (                       ), // O1  - Control register 2
   .i_status            ( 8'hA5                 ), // I8  - Status register
   .o_debug_test_reg    (                       )  // Oxx - Debug/test register
); 

endmodule
