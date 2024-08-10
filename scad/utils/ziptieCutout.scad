use <NopSCADlib/utils/fillet.scad>

module zipTieFullCutout(size=[10, 5, 2], depth=2, triangular=false) {
    translate([-size.x/2, -size.y/2, - size.z - depth]) {
        difference() {
            union() {
                cube(size);
                translate([size.x - size.z, 0, 0])
                    cube([size.z, size.y, size.z + depth + eps]);
                translate([0, 0, 0])
                    cube([size.z, size.y, size.z + depth + eps]);
            }
            // add a fillet to make it easier to insert the ziptie
            translate([size.x + eps, -eps, -eps])
                rotate([90, 0, 180])
                    if (triangular)
                        right_triangle(1.5, 1.5, size.y + 2*eps, center=false);
                    else
                        fillet(2, size.y + 2*eps); // rounded fillet seems to work better than triangular one
            translate([0, size.y + eps, -eps])
                rotate([90, 0, 0])
                    if (triangular)
                        right_triangle(1.5, 1.5, size.y + 2*eps, center=false);
                    else
                        fillet(2, size.y + 2*eps); // rounded fillet seems to work better than triangular one
        }
    }
}
