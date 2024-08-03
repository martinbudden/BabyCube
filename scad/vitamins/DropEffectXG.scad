include <../config/global_defs.scad>

include <NopSCADlib/utils/rounded_cylinder.scad>

module dropEffectImportStl(file) {
    import(str("../../../stlimport/DropEffect/", file, ".stl"), convexity=10);
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
        color(silver)
            dropEffectImportStl("XG_Hotend_Adaptor");
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
