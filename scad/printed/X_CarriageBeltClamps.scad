include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>

use <../vitamins/bolts.scad>

use <X_Carriage.scad>


beltTidySize = [tidyHoleSpacing() + 8, 7, 2];

module Belt_Tidy_stl() {
    size = beltTidySize;

    stl("Belt_Tidy")
        difference() {
            rounded_cube_xy(size, 1.5, xy_center=true);
            for (x = [-tidyHoleSpacing()/2, tidyHoleSpacing()/2])
                translate([x, 0, 0])
                    boltHoleM3(size.z);
        }
}

module Belt_Tidy_hardware() {
    size = beltTidySize;

    for (x = [-tidyHoleSpacing()/2, tidyHoleSpacing()/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}


beltClampSize = [clampHoleSpacing() + 8, 7, 2];

module Belt_Clamp_stl() {
    size = beltClampSize;

    stl("Belt_Clamp")
        color(pp2_colour)
            difference() {
                rounded_cube_xy(size, 1.5, xy_center=true);
                for (x = [-clampHoleSpacing()/2, clampHoleSpacing()/2])
                    translate([x, 0, 0])
                        boltHoleM3(size.z);
            }
}

module Belt_Clamp_hardware() {
    size = beltClampSize;

    for (x = [-clampHoleSpacing()/2, clampHoleSpacing()/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}

module Belt_Tensioner_stl() {
    size = beltTensionerSize();
    holeLength = size.x + size.y/8; // length of rectangular part plus a quarter the radius of the cylinder

    stl("Belt_Tensioner")
        difference() {
            union() {
                translate([size.x/2, 0, 0])
                    cylinder(d=size.y, h=size.z, center=true);
                cube(size, center=true);
            }
            translate([-size.x/2, -size.y/2, -size.z/2-eps])
                fillet(0.5, size.z + 2*eps);
            translate([-size.x/2, size.y/2, -size.z/2-eps])
                rotate(-90)
                    fillet(0.5, size.z + 2*eps);
            translate([-size.x/2 - eps, 0, 0])
                rotate([90, 0, 90])
                    boltHoleM3(holeLength, horizontal = true, chamfer_both_ends = false);
        }
}

module Belt_Tensioner_hardware() {
    size = beltTensionerSize();
    boltLength = 20;
    holeLength = size.x + 2; // length of rectangular part, plus two into the cylinder

    translate([holeLength - size.x/2 - boltLength, 0, 0])
        rotate([0, -90, 0])
            boltM3Caphead(boltLength);
}
