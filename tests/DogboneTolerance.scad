//!Displays sheet with dogbones, to test tolerances.

include <../scad/config/global_defs.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/sheets.scad>

include <../scad/utils/cutouts.scad>

module cutouts(size, toolType=CNC) {
    cuttingRadius = cuttingRadius(toolType);
    kerf = kerf(toolType);

    t0 = 0.025;
    t1 = 0.050;
    t2 = 0.075;
    t3 = 0.100;

    M3_clearance_radius = 3.3 / 2;

    // use kerf on left side
    translate([20, 60])
        circle(1.5 - kerf/2);
    translate([20, 40])
        circle(M3_clearance_radius - kerf/2);
    translate([20, 20])
        circle(2.5 - kerf/2);

    // no kerf along bottom
    translate([40, 20])
        circle(1.5);
    translate([60, 20])
        circle(M3_clearance_radius);
    translate([80, 20])
        circle(2.5);

    /*module slot() {
        hull() {
            for (y  = [-4, 4])
                translate([0, y])
                    circle(1.5 - kerf/2);
        }
    }
    module V() {
        hull() {
            translate([0, -4])
                circle(1.5 - kerf/2);
            translate([-3.5, 4])
                circle(1.5 - kerf/2);
        }
        hull() {
            translate([0, -4])
                circle(1.5 - kerf/2);
            translate([3.5, 4])
                circle(1.5 - kerf/2);
        }
    }

    translate([105, 40])
        slot();
    for (x = [-3, 3])
        translate([60 + x, 15])
            slot();
    translate([55, 65]) {
        slot();
        translate([8, 0])
            V();
    }*/

    xStep = 20;
    dogboneYSize = [xStep, size.z*2, 0]; //dogboneY has ends of bones going in Y direction
    // t1 on bottom
    for (x = [0 : xStep*2 : size.x])
        translate([x, 0])
            edgeCutout_y(dogboneYSize, cuttingRadius, t1, kerf);
    // t3 on top
    for (x = [0 : xStep*2 : size.x])
        translate([x, size.y])
            edgeCutout_y(dogboneYSize, cuttingRadius, t3, kerf);

    yStep = 20;
    dogboneXSize = [size.z*2, yStep, 0];
    // t2 on left side
    for (y = [0 : yStep*2 : size.y])
        translate([0, y])
            edgeCutout_x(dogboneXSize, cuttingRadius, t2, kerf);
    // t0 on right side
    for (y = [0 : yStep*2 : size.y])
        translate([size.x, y])
            edgeCutout_x(dogboneXSize, cuttingRadius, t0, kerf);

}

module DogboneCNCToleranceTest(size=[120, 80, 3]) {
    dxf("DogboneCNCToleranceTest");
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2])
                cutouts(size, toolType=CNC);
        }
}

module DogboneLSRToleranceTest(size=[120, 80, 3]) {
    dxf("DogboneLSRToleranceTest");
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2])
                cutouts(size, toolType=WJ);
        }
}

module DogboneTolerance_test() {
    size = [120, 80, 3];
    color(pp2_colour)
    render_2D_sheet(CF3, w=size.x, d=size.y)
        DogboneCNCToleranceTest(size);
}


//DogboneTolerance_test();
//DogboneCNCToleranceTest();
rotate([25, 0, 0])
if ($preview)
    DogboneTolerance_test();
else
    DogboneCNCToleranceTest();