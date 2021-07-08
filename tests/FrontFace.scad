//! Display the front face

include <NopSCADlib/core.scad>

use <../scad/printed/FrontFace.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/XY_IdlerBracket.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Front_Face_test() {
    Front_Face_CF_assembly();
    //Front_Face_CF();
    //Front_Face_CF_dxf();
    //frontLowerChordSKR_1_4(headless=false);
    XY_Idler_Bracket_Left_assembly();
    XY_Idler_Bracket_Right_assembly();
}

if ($preview)
    Front_Face_test();
