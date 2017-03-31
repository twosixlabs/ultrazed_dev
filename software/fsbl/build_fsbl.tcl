# Build the FSBL
set hwdsgn [open_hw_design ultrazed_top.hdf]
generate_app -hw $hwdsgn -os standalone -proc psu_cortexa53_0 -app zynqmp_fsbl -compile -sw fsbl -dir ./build
exit
