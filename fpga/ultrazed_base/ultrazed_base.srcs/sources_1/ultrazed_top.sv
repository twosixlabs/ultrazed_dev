/* UltraZed Top Level */
module ultrazed_top (
    // ZynqMP LEDs
    output [ 7:0]   ps_leds        
);      

/* Interfaces */


/* REG/WIRE declarations */


/* Continuous Assignments */

/* ZynqMP Top Level - PS Interfaces + AXI Address Decode */                                                
zynqmp_top_wrapper zynq_ps_axi_decode(    
    // ZynqMP PS Interfaces
    .led_8bits_tri_o              ( ps_leds )
);

endmodule
