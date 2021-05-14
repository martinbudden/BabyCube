//! Display the extruder

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/vitamins/extruder.scad>


//$explode = 1;
//$pose = 1;
module Extruder_test() {
    Extruder_MK10_Dual_Pulley(corkDamperThickness=2);
}

module ExtruderOffset_test() {
    NEMA_type = NEMA17;
    size = [42, 60];
    linear_extrude(2)
        difference() {
            rounded_square(size, 2);
            circle(r=NEMA_boss_radius(NEMA_type));
            NEMA_screw_positions(NEMA_type)
                circle(r=M3_clearance_radius);
        }
    markerSize = [1, 8, 15];
    translate([-markerSize.x/2+4, -size.y/2])
        rounded_cube_xy(markerSize, 0);
    translate([-markerSize.x/2-4.5, size.y/2-markerSize.y])
        rounded_cube_xy(markerSize, 0);
}

//Extruder_MK10_Dual_Pulley(corkDamperThickness=2);
//rotate(180)
//ExtruderOffset_test();
if ($preview)
    Extruder_test();
