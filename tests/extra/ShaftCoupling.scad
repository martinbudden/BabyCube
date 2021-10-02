//! Display a shaft coupling

include <NopSCADlib/utils/core/core.scad>
include <../scad/printed/ShaftCoupling.scad>


//$explode = 1;
//$pose = 1;
module ShaftCoupling_test() {
    Shaft_Coupling_8x5_stl();
}

if ($preview)
    ShaftCoupling_test();
//Z_Spacer_stl();
