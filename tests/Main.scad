//! Display the main assembly

include <NopSCADlib/utils/core/core.scad>

include <../scad/utils/printParameters.scad>

use <../scad/Main.scad>
use <../scad/MainAssembly.scad>
use <../scad/MainAssemblyCF.scad>


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
    //Stage_5_assembly();
    main_assembly();
}

module position(a=[55, 0, 25], t=[0, 0, 0], d=undef) {
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
    rotate($vpr.z == 315 ? -90 + 30 : 0)
        translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, 0])
            Main_test();
