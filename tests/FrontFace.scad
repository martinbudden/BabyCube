//! Display the front face

include <NopSCADlib/utils/core/core.scad>

use <../scad/printed/FrontFace.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/XY_IdlerBracket.scad>

include <../scad/config/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Front_Face_test() {
    if (_useCNC) {
        Front_Face_CF_assembly();
        XY_Idler_Bracket_Left_assembly();
        XY_Idler_Bracket_Right_assembly();
    } else {
        frontLowerChordSKR_1_4(headless=false);
    }
}

if ($preview)
    Front_Face_test();
