# Build the PMU
set hwdsgn [open_hw_design ultrazed_top.hdf]
generate_app -hw $hwdsgn -os standalone -proc psu_pmu_0 -app zynqmp_pmufw -compile -sw pmufw -dir ./build
exit
