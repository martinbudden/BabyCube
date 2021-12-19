include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../vitamins/bolts.scad>

include <Printhead.scad>


fanDuctTabThickness = 2;

module fanDuct(printHeadHotendOffsetX, jetOffset=0, chimneySizeZ=14) {
    blower_type = BL30x10;
    blowerSize = blower_size(blower_type);

    exit = blower_exit(blower_type);
    wallLeft = blower_wall_left(blower_type);
    wallRight = blower_wall_right(blower_type);
    base = blower_base(blower_type);
    top = blower_top(blower_type);

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
            tabTopSize = [33.5, fanDuctTabThickness, 5];
            tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
            hull() {
                translate([offsetX, -fanDuctTabThickness, -chimneySize.z + 0.5])
                    rounded_cube_xy(tabBottomSize, 0.5);
                translate([30 - tabTopSize.x, -fanDuctTabThickness, -tabTopSize.z])
                    rounded_cube_xy(tabTopSize, 0.5);
            }
        }
        fanDuctHolePositions(-fanDuctTabThickness)
            rotate([-90, 180, 0])
                boltHoleM2(fanDuctTabThickness, horizontal=true);

        flueSize = chimneyTopSize - [1.5, 1.5, 0];
        translate([wallLeft + 1.5/2, -chimneySize.y + top + 1.5/2, -chimneySize.z + eps])
            rounded_cube_xy(flueSize, 1);

        jetEndSize = [5, 2, 2];
        jetStartSize = [16, 2, 2];
        translate([12.5 + jetOffset, -8, 14 - chimneySize.z])
            #hull() {
                translate([-jetEndSize.x/2, 6 + 2 + printHeadHotendOffsetX, -21-1])
                    cube(jetEndSize);
                translate([-jetStartSize.x/2, 0, -13])
                    cube(jetStartSize);
            }
    }
}

module Fan_Duct_hardware(xCarriageType, hotendDescriptor) {
    fanDuctHolePositions(-fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2Caphead(6);
}
