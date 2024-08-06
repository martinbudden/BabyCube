//! Display the Face Joiners

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <../scad/config/Parameters_Main.scad>
include <../scad/utils/HolePositions.scad>
use <../scad/printed/BackFaceJoiners.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/TopFaceJoiners.scad>


//$explode = 1;
//$pose = 1;
module Joiners_test(justBase=false) {
    Base_Front_Joiner_stl();
    rotate([90, 0, 90])
        Base_Left_Joiner_stl();
    translate([eX + 2*eSizeX, 0, 0])
        rotate([-90, 0, 90])
            Base_Right_Joiner_stl();
    //BaseAL();
    //Base_assembly();
    translate_z(baseCoverOutsideHeight)
        vflip()
            Base_Cover_CF_stl();

    if (!justBase) {
        Back_Face_Top_Joiner_stl();
        rotate([90, 0, 90])
            Back_Face_Left_Joiner_stl();
        translate([eX + 2*eSizeX + eps, 0, 0])
            rotate([-90, 0, 90])
                Back_Face_Right_Joiner_stl();

        Top_Face_Front_Joiner_stl();
        rotate([90, 0, 90])
            Top_Face_Left_Joiner_stl();
        translate([eX + 2*eSizeX + eps, 0, 0])
            rotate([-90, 0, 90])
                Top_Face_Right_Joiner_stl();
    }
}

if ($preview)
    Joiners_test(false);
