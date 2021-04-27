//! Display the extruder

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/vitamins/extruder.scad>


//$explode = 1;
//$pose = 1;
module Extruder_test() {
    Extruder_MK10_Dual_Pulley(corkDamperThickness=2);
}

if ($preview)
    Extruder_test();
