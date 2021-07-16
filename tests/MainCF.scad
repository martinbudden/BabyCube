//! Display the main assembly in carbon fiber

include <NopSCADlib/core.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>

use <../scad/utils/printParameters.scad>
use <../scad/utils/printParameters.scad>

use <../scad/Main.scad>
use <../scad/MainCF.scad>
use <../scad/MainAssembly.scad>
use <../scad/MainAssemblyCF.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module MainCF_test() {
    echoPrintSize();
    echoPrintParameters();

    //Base_assembly();
    //Back_Face_CF_assembly();
    //Left_Face_CF_assembly();
    //Right_Face_CF_assembly();
    //Top_Face_CF_assembly();
    //Front_Face_CF_assembly();
    //Stage_5_CF_assembly();
    BC200CF_assembly();
}

if ($preview)
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2])
        MainCF_test();


module center() {
    translate([-(2*eSizeX + eX)/2, -(2*eSizeY + eY)/2, -eZ/2])
        children();
}
