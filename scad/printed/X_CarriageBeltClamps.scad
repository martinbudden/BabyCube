include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>

include <../vitamins/bolts.scad>

use <X_Carriage.scad>


function beltTidySize(beltWidth) = [tidyHoleSpacing(beltWidth) + 8, 7, 2];

module beltTidy(beltWidth) {
    size = beltTidySize(beltWidth);
    tidyHoleSpacing = tidyHoleSpacing(beltWidth);

    difference() {
        rounded_cube_xy(size, 1.5, xy_center=true);
        for (x = [-tidyHoleSpacing/2, tidyHoleSpacing/2])
            translate([x, 0, 0])
                boltHoleM3(size.z);
    }
}

module Belt_Tidy_hardware(beltWidth) {
    size = beltTidySize(beltWidth);
    tidyHoleSpacing = tidyHoleSpacing(beltWidth);

    for (x = [-tidyHoleSpacing/2, tidyHoleSpacing/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}


function beltClampSize(beltWidth) = [clampHoleSpacing(beltWidth) + 8, 7, 2];

module beltClamp(beltWidth) {
    size = beltClampSize(beltWidth);
    clampHoleSpacing = clampHoleSpacing(beltWidth);

    difference() {
        rounded_cube_xy(size, 1.5, xy_center=true);
        for (x = [-clampHoleSpacing/2, clampHoleSpacing/2])
            translate([x, 0, 0])
                boltHoleM3(size.z);
    }
}

module Belt_Clamp_hardware(beltWidth) {
    size = beltClampSize(beltWidth);
    clampHoleSpacing = clampHoleSpacing(beltWidth);

    for (x = [-clampHoleSpacing/2, clampHoleSpacing/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(10);
}

module beltTensioner(beltWidth) {
    size = beltTensionerSize(beltWidth);
    holeLength = size.x + size.y/8; // length of rectangular part plus a quarter the radius of the cylinder

    difference() {
        union() {
            translate([size.x/2, 0, 0])
                cylinder(d=size.y, h=size.z, center=true);
            cube(size, center=true);
        }
        translate([-size.x/2, -size.y/2, -size.z/2 - eps])
            fillet(0.5, size.z + 2*eps);
        translate([-size.x/2, size.y/2, -size.z/2 - eps])
            rotate(-90)
                fillet(0.5, size.z + 2*eps);
        translate([-size.x/2 - eps, 0, 0])
            rotate([90, 0, 90])
                boltHoleM3(holeLength, horizontal = true, chamfer_both_ends = false);
    }
}

module Belt_Tensioner_hardware(beltWidth) {
    size = beltTensionerSize(beltWidth);
    boltLength = 20;
    holeLength = size.x + 2; // length of rectangular part, plus two into the cylinder

    translate([holeLength - size.x/2 - boltLength, 0, 0])
        rotate([0, -90, 0])
            boltM3Caphead(boltLength);
}
