//!Displays sheet with dogbones, to test tolerances.

include <../scad/config/global_defs.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/sheets.scad>

include <../scad/utils/cutouts.scad>

module cutouts(size, toolType=CNC) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    kerf = toolType == WJ ? wjKerf : 0;

    t0 = 0.05;
    t1 = 0.075;
    t2 = 0.1;
    t3 = 0.125;
    
    M3_clearance_radius = 3.3 / 2;

    translate([15, 60])
        circle(1.5 - kerf/2);
    translate([15, 40])
        circle(M3_clearance_radius - kerf/2);
    translate([15, 20])
        circle(2.5 - kerf/2);

    module slot() {
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
    }

    xStep = 20;
    dogboneXSize = [xStep, size.z*2, 0];
    for (x = [0 : xStep*2 : size.x])
        translate([x, 0])
            edgeCutout_y(dogboneXSize, cuttingRadius, t0, kerf);
    for (x = [0 : xStep*2 : size.x])
        translate([x, size.y])
            edgeCutout_y(dogboneXSize, cuttingRadius, t1, kerf);

    yStep = 20;
    dogboneYSize = [size.z*2, yStep, 0];
    for (y = [0 : yStep*2 : size.y])
        translate([0, y])
            edgeCutout_x(dogboneYSize, cuttingRadius, t0, kerf);
    for (y = [0 : yStep*2 : size.y])
        translate([size.x, y])
            edgeCutout_x(dogboneYSize, cuttingRadius, t1, kerf);

}

module DogboneCNCToleranceTest(size=[120, 80, 3]) {
    dxf("DogboneCNCToleranceTest")
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2])
                cutouts(size, toolType=CNC);
        }
}

module DogboneWJToleranceTest(size=[120, 80, 3]) {
    dxf("DogboneWJToleranceTest")
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2])
                cutouts(size, toolType=WJ);
        }
}

module DogboneTolerance_test() {
    size = [120, 80, 3];
    render_2D_sheet(CF3, w=size.x, d=size.y)
        DogboneCNCToleranceTest(size);
}

if ($preview)
    DogboneTolerance_test();
else
    DogboneWJToleranceTest();