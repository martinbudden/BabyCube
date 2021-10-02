//! Display the print bed

include <NopSCADlib/utils/core/core.scad>

use <../scad/printed/Printbed.scad>
use <../scad/printed/Printbed3point.scad>
use <../scad/printed/Z_Carriage.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Printbed_test() {
    //Heated_Bed_dxf();
    //Print_bed_assembly();
    //Printbed_Frame_stl();
    //Print_bed_3_point_assembly();
    //Print_bed_3_point_printed_stage_1_assembly();
    Print_bed_3_point_printed_assembly();
    //printbed(100);
    //hflip() zCarriage(100);
    *translate_z(-11.5)
        printbed3point();
}

if ($preview)
    translate([-eX/2 - eSizeX, -eY - 2*eSizeY + _zLeadScrewOffset, 0]) // this moves it to the back face
        Printbed_test();
else
    Printbed_Frame_stl();
