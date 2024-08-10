include <../config/global_defs.scad>

include <NopSCADlib/utils/rounded_cylinder.scad>

module revoImportStl(file) {
    import(str("../../../stlimport/E3D/", file, ".stl"), convexity=10);
}

module revoImport3mf(file) {
    import(str("../../../stlimport/E3D/", file, ".3mf"), convexity=10);
}

// z-distance from top of RevoVoron to tip of nozzle is 48.80mm, see https://e3d-online.zendesk.com/hc/en-us/articles/5927310441373-Revo-Voron-Datasheet
function revoVoronSizeZ() = 48.8;

module E3DRevoVoron(coreRotate=90) {
    vitamin(str(": E3D Revo Voron heatsink"));
    vitamin(str(": E3D Revo HeaterCore"));

    translate_z(revoNozzleOffsetZ() - 1)
        revoVoronHeatsink();
    /*
    color(grey(90))
        intersection() {
            size = [25, 25, 50];
            rotate(45)
                translate([-size.x/2, -size.y/2, 0])
                    cube(size);
            rotate(coreRotate)
            translate([-13.4, 16.7, 9.4])
                rotate(90)
                    revoImport3mf("RevoHeaterCore");
            *translate([0, 0, 22.8])
                rotate([90, 0, -90])
                    revoImportStl("RevoVoron");
        } // end intersection
    */
    E3DRevoNozzle();
}

module revoVoronBoltPositions(z=0) {
    // 10 by 8.5 bolt spacing
    for (x = [-5, 5], y = [-4.25, 4.25])
        translate([x, y, z])
            children();
}

function revoNozzleOffsetZ() = 22.8;

revoNozzleLength = 44.1;

module E3DRevoNozzle() {
    vitamin(str(": E3D Revo nozzle"));

    brassColor="#B5A642";
    difference() {
        union() {
            color(brassColor) {
                cylinder(h=2, r1=0.6, r2=2.1);
                translate_z(2)
                    cylinder(h=5, r=5);
                translate_z(7)
                    cylinder(h=12, r=3);
                translate_z(22)
                    cylinder(h=0.8, r=3);
                translate_z(22.8)
                    cylinder(h=revoNozzleLength - revoNozzleOffsetZ(), r=1.5);
            }
            color("silver")
                translate_z(18)
                    cylinder(h=4, r=1);
            color("red")
                translate_z(2.5 + 5)
                    vflip()
                        rounded_cylinder(h=5.1, r=6.55, r2=1);
            color(grey(20))
                translate_z(12 + 7.5 - eps)
                    vflip()
                        rounded_cylinder(h=12, r=8.4, r2=1);
        } // end union
        translate_z(-eps)
            cylinder(h=revoNozzleLength + 2*eps, r=0.4);
    } // end difference
}

module revoVoronHeatsinkImport() {
    translate_z(-revoNozzleOffsetZ() + 1)
    color("crimson")
        translate([-13.4, 16.7, 9.4])
            rotate(90)
                revoImport3mf("RevoVoronHeatsink");
}

module revoVoronHeatsink() {
    module fin(r, w=14) {
        linear_extrude(0.75) {
            difference() {
                circle(r=r);
                circle(r=1.5);
                translate([-1.1*r, w/2])
                    square([2.2*r, r]);
                translate([-1.1*r, -w/2 -r])
                    square([2.2*r, r]);
                for (r = [0, 180])
                    rotate(r)
                        translate([-9.5, -7.1, 0])
                            right_triangle(6,3.5,0);
                for (m = [ [1, 0, 0], [0, 1, 0] ])
                    mirror(m)
                        translate([-9.5, -7.1, 0])
                            right_triangle(6,3.5,0);
            }
        }
    }

    color(crimson)  {
        difference() {
            cylinder(h=27, r1=3.6, r2=3.15);
            translate_z(-eps)
                cylinder(h=27 + 2*eps, r=1.5);
        }
        for (i = [0 : 9])
            translate_z(1 + 2.05 * i)
                fin(9.4 - 0.223*i);
        translate_z(21.5)
            fin(7.9);

        // top
        translate_z(23.5)
            difference() {
                union() {
                    cylinder(h=1, r1=8.35, r2=9);
                    translate_z(1)
                        cylinder(h=1.5, r=9);
                    translate_z(2.5)
                        cylinder(h=1, r1=9, r2=8.35);
                }
                translate_z(-eps)
                    cylinder(h=3.5 + 2*eps, r=1.5);
                revoVoronBoltPositions(-eps)
                    cylinder(h=3.5 + 2*eps, r=2.5/2); // M3 tap radius

                r = 9;
                w = 14;
                for (y = [w/2, -w/2 - r])
                    translate([-1.1*r, y, -eps])
                        cube([2.2*r, r, 3.5 + 2*eps]);
            }
    }
}

