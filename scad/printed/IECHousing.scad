include <../global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/vitamins/iecs.scad>
include <NopSCADlib/vitamins/rockers.scad>

use <NopSCADlib/utils/fillet.scad>


function iecType() = IEC_320_C14_switched_fused_inlet;
function iecHousingSize() = [56, 46, 44];

module IEC_Housing_stl() {
    size = iecHousingSize();
    stl("IEC_Housing")
        color(pp4_colour)
            rotate(180) // rotate so rear seam underneath and so hidden when assembled
                translate([size.x/2, -size.y/2, -size.z - 3])
                    mirror([1, 0, 0])
                        iecHousingStl(iecHousingSize());
}

module iecHousingStl(size) {
    fillet = 2;
    cutoutSize = [size.x - 6, size.y - 14];
    baseThickness = 3;
    blockHeight = size.z - 25 - baseThickness;

    triangleSize = [8, 7];
    difference() {
        rounded_cube_xy([size.x, size.y, baseThickness], fillet);
        cableCutoutSize = [10, 10, baseThickness + 2*eps];
        *translate([size.x - cableCutoutSize.x - (size.x - cutoutSize.x)/2, 5, -eps])
            rounded_cube_xy(cableCutoutSize, fillet);
    }
    translate([size.x/2, size.y/2, baseThickness])
        difference() {
            union() {
                linear_extrude(size.z - baseThickness, convexity=8)
                    difference() {
                        rounded_square([size.x, size.y], fillet);
                        rounded_square(cutoutSize, 1);
                    }
            } // end union

            translate([size.x/2 - 25, -size.y/2 + 5, -eps])
                rounded_cube_xy([20, 10, blockHeight - 5], fillet);
            translate([size.x/2 - 25, -cutoutSize.y/2, -eps])
                rotate(180)
                    fillet(fillet, blockHeight - 5 + 2*eps);
            
            holeSize = [5, 10, 10];
            translate([size.x/2 - holeSize.x + eps, -size.y/2 + 5, eps]) {
                translate([-fillet, 0, 0])
                    cube(holeSize + [fillet, 0, 0]);
                translate([0, holeSize.y, 0])
                    fillet(fillet, holeSize.z);
                translate([holeSize.x, holeSize.y, 0])
                    rotate(90)
                        fillet(fillet, holeSize.z);
                translate([holeSize.x, 0, 0])
                    rotate(180)
                        fillet(fillet, holeSize.z);
            }
            rotate(90)
                translate_z(size.z)
                    iec_screw_positions(iecType())
                        vflip()
                            boltHoleM4Tap(10);
        } // end difference
}

