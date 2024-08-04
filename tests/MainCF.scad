//! Display the main assembly in carbon fiber

include <NopSCADlib/utils/core/core.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>

include <../scad/utils/printParameters.scad>

use <../scad/MainCF.scad>
use <../scad/assemblies/MainAssemblyCF.scad>

include <../scad/config/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module MainCF_test() {
    echoPrintSize();
    //echoPrintParameters();
    //Base_CF_assembly();
    //Back_Face_CF_Stage_1_assembly();
    //Back_Face_CF_assembly();
    //Left_Face_CF_assembly();
    //Right_Face_CF_assembly();
    //Top_Face_CF_assembly();
    //translate_z(3)  Top_Face_CF_Stage_1_assembly();
    //Front_Face_CF_assembly();
    //Stage_1_CF_assembly();
    //Stage_2_CF_assembly();
    //Stage_3_CF_assembly();
    //Stage_4_CF_assembly();
    //Stage_5_CF_assembly();
    //BC200CF_debug();
    BC200CF_assembly(test=true);
}

if ($preview)
    MainCF_test();


module center() {
    translate([-(2*eSizeX + eX)/2, -(2*eSizeY + eY)/2, -eZ/2])
        children();
}
