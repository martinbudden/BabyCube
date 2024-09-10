include <NopSCADlib/utils/rounded_cylinder.scad>
include <../vitamins/bolts.scad>
include <NopSCADlib/vitamins/fans.scad>

module dropEffectImportStl(file) {
    import(str("../stlimport/DropEffect/", file, ".stl"), convexity=10);
}

function dropEffectXGSizeZ() = 48.5;

module DropEffectXG() {
    vitamin(str(": DropEffect XG Hotend"));

    translate([0, 0, 17 - dropEffectXGSizeZ()]) {
        brassColor = "#B5A642";
        color(brassColor)
            dropEffectImportStl("XG_Hotend");
        color(silver)
            dropEffectImportStl("XG_Hotend_Nozzle");
        color(silver)
            dropEffectImportStl("XG_Hotend_Bracket");
        color([0.7, 0.7, 0.7])
            dropEffectImportStl("XG_Hotend_Adaptor");
    }
}

module DropEffectXGFan() {
    fan = fan25x10;
    translate([0, -13, -15])
        rotate([0, 90, -90]) {
            fan(fan);
            pitch = fan_hole_pitch(fan);
            // fan only attached by 2 bolts
            for(y = [-pitch, pitch])
                translate([pitch, y, fan_depth(fan)/2])
                    color([0.25, 0.25, 0.25])
                        boltM2p5Caphead(14);
        }
}

module DropEffectXGTopBoltPositions(z=0) {
    for (x = [-5, 5], y = [-5, 5])
        translate([x, y, z])
            children();
}

module DropEffectXGSideBoltPositions() {
    for (z = [-5, 5])
        translate([-14.4, -3, z - 16])
            rotate([0, -90, 0])
                children();
}
