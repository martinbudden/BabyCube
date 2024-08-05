include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../vitamins/bolts.scad>


fanDuctTabThickness = 2;

module fanDuctHolePositions(blower_type=BL30x10, z=0) {
    blowerSizeX = blower_size(blower_type).x;
    xOffsets = blowerSizeX == 30 ? [-1, 27] : [4, 37];
    for (x = xOffsets)
        translate([x, z, -3])
            children();
}

module fanDuct(blower_type=BL30x10, printheadHotendOffsetX, jetOffset=0, chimneySizeZ=14) {
    blowerSize = blower_size(blower_type);

    exit = blower_exit(blower_type);
    wallLeft = blower_wall_left(blower_type);
    wallRight = blower_wall_right(blower_type);
    base = blower_base(blower_type);
    top = blower_top(blower_type);

    translate([blowerSize.x/2 - 15, 0, 0])
    difference() {
        fillet = 2;
        offsetX = 1;
        chimneySize = [exit + wallLeft + wallRight - offsetX, blowerSize.z, chimneySizeZ];
        chimneyTopSize = [exit, blowerSize.z - base - top, chimneySize.z + 2];
        union() {
            translate([0, -chimneySize.y, -chimneySize.z]) {
                translate([offsetX, 0, 0])
                    rounded_cube_xy(chimneySize, fillet);
                translate([wallLeft, top, 0])
                    rounded_cube_xy(chimneyTopSize, fillet);
                translate([offsetX, 0, -3]) {
                    // the foot
                    hull() {
                        rounded_cube_xy([chimneySize.x, chimneySize.y, 5], fillet);
                        translate([0, 11, 0])
                            rounded_cube_xy([chimneySize.x, 5, 3], fillet);
                    }
                }
            }
            tabTopSize = [chimneySize.x + 10, fanDuctTabThickness, 5];
            tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
            hull() {
                translate([offsetX, -fanDuctTabThickness, -chimneySize.z + 0.5])
                    rounded_cube_xy(tabBottomSize, 0.5);
                translate([blowerSize.x/2 + 15 - tabTopSize.x, -fanDuctTabThickness, -tabTopSize.z])
                    rounded_cube_xy(tabTopSize, 0.5);
            }
        }
        translate([15 - blowerSize.x/2, 0, 0])
            fanDuctHolePositions(blower_type, -fanDuctTabThickness)
                rotate([-90, 180, 0])
                    boltHoleM2(fanDuctTabThickness, horizontal=true);

        flueSize = chimneyTopSize - [1.5, 1.5, 0];
        translate([wallLeft + 1.5/2, -chimneySize.y + top + 1.5/2, -chimneySize.z + eps])
            rounded_cube_xy(flueSize, 1);

        jetEndSize = [5, 2, 2];
        jetStartSize = [16, 2, 2];
        if (!exploded())
            translate([12.5 + jetOffset, -8, 14 - chimneySize.z])
                #hull() {
                    translate([-jetEndSize.x/2, 6 + 2 + printheadHotendOffsetX, -21-1])
                        cube(jetEndSize);
                    translate([-jetStartSize.x/2, 0, -13])
                        cube(jetStartSize);
                }
    }
}

module Fan_Duct_hardware(blower_type=BL30x10) {
    fanDuctHolePositions(blower_type, -fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2Caphead(6);
}
