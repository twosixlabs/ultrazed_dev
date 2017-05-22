# I/O Voltage/Pin Contraints + Tool Properties

# Tool Properties
#============================================================
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# PL Reference Clock
#============================================================
set_property IOSTANDARD DIFF_SSTL18_I [get_ports i_pl_ref_clk*]
set_property PACKAGE_PIN N4 [get_ports i_pl_ref_clk_p]
# I/O JX1 Pin 117 - JX1_HP_DP_36_GC_P
set_property PACKAGE_PIN N3 [get_ports i_pl_ref_clk_n]
# I/O JX1 Pin 119 - JX1_HP_DP_36_GC_N

# PL User LED's
#============================================================
set_property IOSTANDARD LVCMOS18 [get_ports o_ps_leds*]
set_property PACKAGE_PIN U5 [get_ports {o_ps_leds[7]}]
set_property PACKAGE_PIN U6 [get_ports {o_ps_leds[6]}]
set_property PACKAGE_PIN U2 [get_ports {o_ps_leds[5]}]
set_property PACKAGE_PIN T3 [get_ports {o_ps_leds[4]}]
set_property PACKAGE_PIN T4 [get_ports {o_ps_leds[3]}]
set_property PACKAGE_PIN T7 [get_ports {o_ps_leds[2]}]
set_property PACKAGE_PIN T5 [get_ports {o_ps_leds[1]}]
set_property PACKAGE_PIN R7 [get_ports {o_ps_leds[0]}]


