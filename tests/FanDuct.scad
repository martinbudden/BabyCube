//! Display an L-shaped foot

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <../scad/vitamins/bolts.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../scad/printed/X_CarriageFanDuct.scad>


//$explode = 1;
//$pose = 1;
module FanDuct_test() {
    for (blower = [BL30x10, BL40x10])
        translate([blower == BL30x10 ? 0 : 50, 0, 0]) {
            rotate([90, 0, 0]) {
                blower(blower);
                blower_hole_positions(blower)
                translate_z(blower_lug(blower))
                    boltM2p5Caphead(6);
            }
            fanDuct2(blower, jetOffset=[0, 24, -8]);
            fanDuctHolePositions2(blower) 
                boltM2p5Caphead(6);
        }
}

if ($preview)
    FanDuct_test();
