//! Display an L-shaped foot

include <NopSCADlib/core.scad>

use <../scad/printed/Foot.scad>


//$explode = 1;
//$pose = 1;
module Foot_test() {
    vflip()
        Foot_LShaped_8mm_stl();
}

if ($preview)
    Foot_test();
