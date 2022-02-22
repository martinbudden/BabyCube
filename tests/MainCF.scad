//! Display the main assembly in carbon fiber

include <NopSCADlib/utils/core/core.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>

include <../scad/utils/printParameters.scad>

use <../scad/Main.scad>
use <../scad/MainCF.scad>
use <../scad/MainAssembly.scad>
use <../scad/MainAssemblyCF.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module MainCF_test() {
    echoPrintSize();
    //echoPrintParameters();

    //Base_assembly();
    //Back_Face_CF_assembly();
    //Left_Face_CF_assembly();
    //Right_Face_CF_assembly();
    //Top_Face_CF_assembly();
    //Front_Face_CF_assembly();
    //Stage_3_CF_assembly();
    //Stage_4_CF_assembly();
    //Stage_5_CF_assembly();
    //CF_DebugAssembly();
    CF_FinalAssembly();
}

if ($preview)
    MainCF_test();


module center() {
    translate([-(2*eSizeX + eX)/2, -(2*eSizeY + eY)/2, -eZ/2])
        children();
}
