/* Generic AXI4-Lite Interface */

interface axi4_lite 
   #(
      A_WIDTH     = 32, // Width of the address bus
      D_WIDTH     = 32  // Width of the data bus
   );

   /* Constants */ 

   /* REG/WIRE declarations */
   logic [A_WIDTH-1:0]  araddr; 
   logic [2:0]          arprot; 
   logic                arready;
   logic                arvalid;
   logic [A_WIDTH-1:0]  awaddr; 
   logic [2:0]          awprot; 
   logic                awready;
   logic                awvalid;
   logic                bready; 
   logic [1:0]          bresp;  
   logic                bvalid; 
   logic [D_WIDTH-1:0]  rdata;  
   logic                rready; 
   logic [1:0]          rresp;  
   logic                rvalid; 
   logic [D_WIDTH-1:0]  wdata;  
   logic                wready; 
   logic [3:0]          wstrb;  
   logic                wvalid;  
   
   /* Master interface */
   modport Master (     
      // Read Address Channel              
      output araddr,    // Read Address
      output arprot,    // Normal, secure data attributes
      input  arready,   // Read address channel ready
      output arvalid,   // Read address valid
      // Write Address Channel              
      output awaddr,    // Write Address
      output awprot,    // Normal, secure data attributes
      input  awready,   // Write address channel ready
      output awvalid,   // Write address valid
      // Write Response Channel
      output bready,    // Write response channel ready
      input  bresp,     // Write response
      input  bvalid,    // Write response valid
      // Read Data Channel
      input  rdata,     // Read data
      output rready,    // Read data channel ready
      input  rresp,     // Read response
      input  rvalid,    // Read data valid
      // Write Data Channel
      output wdata,     // Write data
      input  wready,    // Write data channel ready
      output wstrb,     // Write strobe
      output wvalid     // Write data valid      
   );
 
   /* Slave interface */
   modport Slave (     
      // Read Address Channel              
      input  araddr,    // Read Address
      input  arprot,    // Normal, secure data attributes
      output arready,   // Read address channel ready
      input  arvalid,   // Read address valid
      // Write Address Channel              
      input  awaddr,    // Write Address
      input  awprot,    // Normal, secure data attributes
      output awready,   // Write address channel ready
      input  awvalid,   // Write address valid
      // Write Response Channel
      input  bready,    // Write response channel ready
      output bresp,     // Write response
      output bvalid,    // Write response valid
      // Read Data Channel
      output rdata,     // Read data
      input  rready,    // Read data channel ready
      output rresp,     // Read response
      output rvalid,    // Read data valid
      // Write Data Channel
      input  wdata,     // Write data
      output wready,    // Write data channel ready
      input  wstrb,     // Write strobe
      input  wvalid     // Write data valid      
   );
   
endinterface

