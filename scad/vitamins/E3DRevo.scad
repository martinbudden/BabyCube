include <../global_defs.scad>

include <NopSCADlib/utils/rounded_cylinder.scad>

module revoImportStl(file) {
    import(str("../../../stlimport/E3D/", file, ".stl"), convexity=10);
}

module revoImport3mf(file) {
    import(str("../../../stlimport/E3D/", file, ".3mf"), convexity=10);
}

// z-distance from top of RevoVoron to tip of nozzle is 48.80mm, see https://e3d-online.zendesk.com/hc/en-us/articles/5927310441373-Revo-Voron-Datasheet
function revoVoronSizeZ() = 48.8;

module E3DRevoVoron() {
    vitamin(str(": E3D Revo Voron heatsink"));
    vitamin(str(": E3D Revo HeaterCore"));

    color("crimson")
        translate([-13.4, 16.7, 9.4])
            rotate(90)
                revoImport3mf("RevoVoronHeatsink");
    color(grey(90))
        intersection() {
            size = [25, 25, 50];
            rotate(45)
                translate([-size.x/2, -size.y/2, 0])
                    cube(size);
            translate([-13.4, 16.7, 9.4])
                rotate(90)
                    revoImport3mf("RevoHeaterCore");
            /*translate([0, 0, 22.8])
                rotate([90, 0, -90])
                    revoImportStl("RevoVoron");*/
        } // end intersection
    E3DRevoNozzle();
}

module revoVoronBoltPositions(z=0) {
    for (x = [-5, 5], y = [-4.5, 4.5])
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
