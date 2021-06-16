//! Display the BTT_SKR_V1_4_TURBO pcb

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/FrontChords.scad>


module BTT_SKR_V1_4_TURBO_test() {
    *color("Skyblue")
        translate([-389.23, -147.9])
            import("../scad/stlimport/BTT_SKR_V1_4_TURBO.stl");

    pcbType = BTT_SKR_V1_4_TURBO;
    *translate([pcb_size(pcbType).x/2, pcb_size(pcbType).y/2, 0])
        pcb(pcbType);

    rotate([90, 0, 180]) {
        Front_Lower_Chord_SKR_1_4_Headless_stl();
        //Front_Lower_Chord_stl();
    }
    translate_z(pcbOffsetFromBase())
        pcbPosition(pcbType)
            pcb(pcbType);
}

if ($preview)
    BTT_SKR_V1_4_TURBO_test();
