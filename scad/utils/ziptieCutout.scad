include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>

module zipTieFullCutout(length = 10) {
    cutoutSize = [length, 5, 2];
    cutoutDepth = 2;

    translate([-cutoutSize.x/2, -cutoutSize.y/2, - cutoutSize.z - cutoutDepth]) {
        difference() {
            union() {
                cube(cutoutSize);
                translate([cutoutSize.x - cutoutSize.z, 0, 0])
                    cube([cutoutSize.z, cutoutSize.y, cutoutSize.z + cutoutDepth + eps]);
                translate([0, 0, 0])
                    cube([cutoutSize.z, cutoutSize.y, cutoutSize.z + cutoutDepth + eps]);
            }
            // add a fillet to make it easier to insert the ziptie
            translate([cutoutSize.x + eps, -eps, -eps])
                rotate([90, 0, 180])
                    fillet(2, cutoutSize.y + 2*eps); // rounded fillet seems to work better than triangular one
                    //right_triangle(1, 1, cutoutSize.y + 2*eps, center=false);
            translate([0, cutoutSize.y + eps, -eps])
                rotate([90, 0, 0])
                    fillet(2, cutoutSize.y + 2*eps); // rounded fillet seems to work better than triangular one
        }
    }
}
