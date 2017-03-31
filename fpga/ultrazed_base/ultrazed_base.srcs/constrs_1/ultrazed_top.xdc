# Board Level Timing Contraints

# Tool Properties
#============================================================
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


# Create Base Clocks
# Clock frequencies in MHz - 1 / Clock Freq(MHz) * 1000 = Clock Period(ns)
#============================================================


# Create Clocks
#============================================================



#============================================================
# PS I/O - False path, this is hard silicon
#============================================================
set_false_path -to [get_ports ps_leds*]

set_property IOSTANDARD LVCMOS18 [get_ports ps_leds*]
set_property PACKAGE_PIN U5 [get_ports ps_leds[7]]
set_property PACKAGE_PIN U6 [get_ports ps_leds[6]]
set_property PACKAGE_PIN U2 [get_ports ps_leds[5]]
set_property PACKAGE_PIN T3 [get_ports ps_leds[4]]
set_property PACKAGE_PIN T4 [get_ports ps_leds[3]]
set_property PACKAGE_PIN T7 [get_ports ps_leds[2]]
set_property PACKAGE_PIN T5 [get_ports ps_leds[1]]
set_property PACKAGE_PIN R7 [get_ports ps_leds[0]]
