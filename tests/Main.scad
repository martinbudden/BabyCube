//! Display the main assembly

include <NopSCADlib/core.scad>

use <../scad/utils/printParameters.scad>
use <../scad/utils/printParameters.scad>

use <../scad/MainAssembly.scad>
use <../scad/MainAssemblyCF.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/PrintheadAssemblies.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Main_test() {
    echoPrintSize();
    //echoPrintParameters();

    //Stage_1_CF_assembly();
    //Stage_1_assembly();
    //Stage_2_assembly();
    //Stage_3_assembly();
    //Stage_4_assembly();
    //fullPrinthead();
    //Stage_5_assembly();
    //Stage_6_assembly();
    FinalAssembly();
}

module position(a = [55, 0, 25], t = [0, 0, 0], d = undef) {
    rotate([55, 0, 25])
        translate_z(is_undef(d) ? 0 : 140 - d)
            rotate([-a.x, 0, 0])
                rotate([0, -a.y, 0])
                    rotate([0, 0, -a.z])
                        translate(-t)
                            children();
}

if ($preview)
    //position([55 + 19, 0, 25 - 15])
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2])
        Main_test();
