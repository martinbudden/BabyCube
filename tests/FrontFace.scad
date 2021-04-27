//! Display the front face

include <NopSCADlib/core.scad>

use <../scad/printed/FrontFace.scad>
use <../scad/printed/FrontChords.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Front_Face_test() {
    Front_Face_CF_assembly();
    //Front_Face_CF();
    //Front_Face_CF_dxf();
    //frontLowerChordSKR_1_4(headless=false);
}

if ($preview)
    Front_Face_test();
