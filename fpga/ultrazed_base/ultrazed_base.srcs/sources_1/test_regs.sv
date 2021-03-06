/*

   Description
   ===========
      Register            Offset    Default
      ----------------    ------    ----------
      version             0x0000    0x00000000
      control             0x0001    0x000AA550
      status              0x0002    0x00000000
      debug               0x000F    0x12345678

*/

module test_regs #(   
   parameter D_WIDTH = 32,
   parameter A_WIDTH = 32,
   parameter A_MSB   = A_WIDTH,
   parameter A_LSB   = 2
) (
   input  logic                  i_clk,                  // I1  - System clock
   input  logic                  i_rst_n,                // I1  - Active-low system clock synchronized reset            
   axi4_lite.Slave               b_reg_axi,              // Bxx - Register/control interface       
   input  logic [15:0]           i_version_major,        // I16 - Version Major
   input  logic [15:0]           i_version_minor,        // I16 - Version Minor
   output logic                  o_en,                   // O1  - Enable
   output logic                  o_en_pls,               // O1  - 
   output logic [ 7:0]           o_reg1,                 // O1  - Control register 1
   output logic [ 7:0]           o_reg2,                 // O1  - Control register 2
   input  logic [ 7:0]           i_status,               // I8  - Status register
   output logic [D_WIDTH-1:0]    o_debug_test_reg        // Oxx - Debug/test register
);      

/* Constants */
// Control Register bitmap
localparam CTRL_REG1_H     = 11;
localparam CTRL_REG1_L     = 4;
localparam CTRL_REG1_WORD  = 8'h55;
localparam CTRL_REG2_H     = 19;
localparam CTRL_REG2_L     = 12;
localparam CTRL_REG2_WORD  = 8'hAA;
localparam EN              = 0;
// Control Register = REG1, REG2, EN
localparam CTRL_REG_WORD   = {12'd0, CTRL_REG2_WORD, CTRL_REG1_WORD, 4'd0};

/* REG/WIRE declarations */ 
typedef enum reg [1:0] {IDLE           = 2'h0,
                        WR_DATA_CH     = 2'h1,
                        WR_RESP_CH     = 2'h2,
                        RD_DATA_CH     = 2'h3
                        } fsm_state;
typedef struct {
   fsm_state            state; 
   // AXI
   logic [A_WIDTH-1:0 ] axi_awaddr;
   logic [A_WIDTH-1:0 ] axi_araddr;
   logic [D_WIDTH-1:0]  axi_rdata;
   logic axi_awready;
   logic axi_wready;
   logic axi_arready;
   logic axi_rvalid;
   logic axi_bvalid;
   // Registers       
   logic ctrl_reg_pls; 
   logic [D_WIDTH-1:0] ctrl_reg;              
   logic [D_WIDTH-1:0] debug_reg;            
} fsm_struct;

(* mark_debug = "false" *) fsm_struct D, Q;

/* Continuous Assignments */
// AXI
assign b_reg_axi.rdata        = Q.axi_rdata;
assign b_reg_axi.awready      = Q.axi_awready;
assign b_reg_axi.wready       = Q.axi_wready;
assign b_reg_axi.arready      = Q.axi_arready;
assign b_reg_axi.rvalid       = Q.axi_rvalid;
assign b_reg_axi.bvalid       = Q.axi_bvalid;
assign b_reg_axi.bresp        = 'd0;
assign b_reg_axi.rresp        = 'd0;
// Registers
assign o_en                   = Q.ctrl_reg[EN];
assign o_en_pls               = Q.ctrl_reg_pls;
assign o_reg1                 = Q.ctrl_reg[CTRL_REG1_H:CTRL_REG1_L];
assign o_reg2                 = Q.ctrl_reg[CTRL_REG2_H:CTRL_REG2_L];
assign o_debug_test_reg       = Q.debug_reg;

/* AXI R/W FSM */
always @ ( posedge i_clk or negedge i_rst_n ) begin
   if ( !i_rst_n ) begin
      Q  <= '{ state     : IDLE,
               ctrl_reg  : CTRL_REG_WORD,
               debug_reg : 32'h12345678, 
               default   :'d0 };
   end else begin
      Q  <= D;
   end
end

always @ ( * ) begin
   // Defaults
   D = Q;
   D.ctrl_reg_pls = 1'b0;
   // Write
   D.axi_awready = 1'b0;
   D.axi_wready = 1'b0;
   D.axi_bvalid = 1'b0;
   // Read
   D.axi_arready = 1'b0;
   D.axi_rvalid = 1'b0;

   // State Transitions
   case ( Q.state )
      IDLE:   
      begin
         // Write operation
         // Write Address Channel:
         // master indicates the write address channel is valid
         // slave indicates the write address channel is ready, and latches the address
         if ( b_reg_axi.awvalid ) begin
            D.axi_awready = 1'b1;
            D.axi_awaddr = b_reg_axi.awaddr;
            D.state = WR_DATA_CH;
         end
         // Read operation
         // Read Address Channel
         // master indicates the read address channel is ready
         // slave indicates read address channel is ready, and latches the address
         if ( b_reg_axi.arvalid ) begin
            D.axi_arready = 1'b1;
            D.axi_araddr = b_reg_axi.araddr;
            D.state = RD_DATA_CH;
         end
      end
      // Write Data Channel:
      // master indicates the write data channel and response channel are ready
      // slave indicates the write data channel is ready
      WR_DATA_CH:
      begin
         if ( b_reg_axi.wvalid & b_reg_axi.bready ) begin
            D.axi_wready = 1'b1;
            D.state = WR_RESP_CH;
         end
      end
      // Write Response Channel:
      // master indicates the write data channel and response channel are still ready
      // slave indicates the response channel is valid
      // write the registers and write response channel, then return to idle
      WR_RESP_CH:
      begin
         if ( b_reg_axi.wvalid & b_reg_axi.bready ) begin
            D.axi_bvalid = 1'b1;
            D.state = IDLE;
            // Write address decoding
            case ( Q.axi_awaddr[A_MSB-1:A_LSB] )
               'd1:
               begin
                  D.ctrl_reg     = b_reg_axi.wdata;
                  D.ctrl_reg_pls = b_reg_axi.wdata[EN] ? 1'b1 : 1'b0;
               end               
               'd15:
               begin
                  D.debug_reg = b_reg_axi.wdata;
               end
               default:
               begin
               end
            endcase
         end
      end
      // Read data channel
      // master indicates the read data channel is ready
      // slave indicates the ready data is valid
      // Read the data and return to idle
      RD_DATA_CH:
      begin
         if ( b_reg_axi.rready ) begin
            D.axi_rvalid = 1'b1;
            D.state = IDLE;
            // Read address decoding
            case ( Q.axi_araddr[A_MSB-1:A_LSB] )
               'd0:
               begin
                  D.axi_rdata = {i_version_major[15:0], i_version_minor[15:0]};
               end
               'd1:
               begin
                  D.axi_rdata = Q.ctrl_reg;
               end      
               'd2:
               begin
                  D.axi_rdata = {24'd0, i_status};
               end                        
               'd15:
               begin
                  D.axi_rdata = Q.debug_reg;
               end
               default:
               begin
                  D.axi_rdata = 32'hDEADBEEF;
               end
            endcase
         end
      end   
   endcase
end 

endmodule

