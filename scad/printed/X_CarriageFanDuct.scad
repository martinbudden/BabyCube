include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>

use <../utils/PrintheadOffsets.scad>

use <../vitamins/bolts.scad>

use <Printhead.scad>
use <X_Carriage.scad>


fanDuctTabThickness = 2;

module Fan_Duct_stl() {
    blower_type = BL30x10;
    blowerSize = blower_size(blower_type);

    exit = blower_exit(blower_type);
    wallLeft = blower_wall_left(blower_type);
    wallRight = blower_wall_right(blower_type);
    base = blower_base(blower_type);
    top = blower_top(blower_type);

    stl("Fan_Duct")
        color(pp2_colour) {
            difference() {
                fillet = 2;
                offsetX = 1;
                chimneySize = [exit + wallLeft + wallRight - offsetX, blowerSize.z, 14];
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
                    tabTopSize = [33.25, fanDuctTabThickness, 5];
                    tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
                    hull() {
                        translate([offsetX, -fanDuctTabThickness, -chimneySize.z+0.5])
                            rounded_cube_xy(tabBottomSize, 0.5);
                        translate([30 - tabTopSize.x, -fanDuctTabThickness, -tabTopSize.z])
                            rounded_cube_xy(tabTopSize, 0.5);
                    }
                }
                fanDuctHolePositions(-fanDuctTabThickness)
                    rotate([-90, 180, 0])
                        boltHoleM2(fanDuctTabThickness, horizontal=true);

                flueSize = chimneyTopSize - [1.5, 1.5, 0];
                translate([wallLeft + 1.5/2, -chimneySize.y + top+1.5/2, -chimneySize.z + eps])
                    rounded_cube_xy(flueSize, 1);

                jetEndSize = [5, 2, 2];
                jetStartSize = [16, 2, 2];
                translate([13, -8, 0])
                    #hull() {
                        translate([-jetEndSize.x/2, 6 + printHeadHotendOffset().x, -21])
                            cube(jetEndSize);
                        translate([-jetStartSize.x/2, 0, -13])
                            cube(jetStartSize);
                    }
            }
        }
}

module Fan_Duct_hardware(xCarriageType, hotend_type) {
    fanDuctHolePositions(-fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2Caphead(6);
}

/*module fanDuctTranslate(xCarriageType, hotend_type) {
    hotendOffset = hotendOffset(xCarriageType);
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);

    translate([hotendOffset.x - grooveMountSize.x, hotendOffset.y + grooveMountOffsetX(hotend_type), 3 - grooveMountSize.z/2 - 38])
        rotate([90, 0, 90])
            children();
}*/
