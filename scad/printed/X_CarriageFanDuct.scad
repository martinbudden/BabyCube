include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../vitamins/bolts.scad>


fanDuctTabThickness = 2;

module fanDuctHolePositions(blower_type=BL30x10, z=0) {
    blowerSizeX = blower_size(blower_type).x;
    xOffsets = blowerSizeX == 30 ? [-1.5, 27] : [3.5, 37];
    for (x = xOffsets)
        translate([x, z, -3])
            children();
}

module fanDuct(blower_type=BL30x10, printheadHotendOffsetX=16, jetOffset=0, chimneySizeZ=14) {
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
            tabTopSize = [chimneySize.x + 11, fanDuctTabThickness, 5];
            tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
            hull() {
                translate([offsetX, -fanDuctTabThickness, -chimneySize.z + 0.5])
                    rounded_cube_xy(tabBottomSize, 0.5);
                translate([offsetX + (tabBottomSize.x - tabTopSize.x)/2, -fanDuctTabThickness, -tabTopSize.z])
                    rounded_cube_xy(tabTopSize, 0.5);
            }
        }
        translate([chimneySize.x + 2*offsetX, -chimneySize.y - eps, -chimneySizeZ - 3 - eps])
            rotate([0, -90, 0])
                right_triangle(3, 3, chimneySize.x+2*offsetX, center=false);

        translate([15 - blowerSize.x/2, 0, 0])
            fanDuctHolePositions(blower_type, -fanDuctTabThickness)
                rotate([-90, 180, 0])
                    boltHoleM2p5(fanDuctTabThickness, horizontal=true);

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


module fanDuctHolePositions2(blower=BL30x10, z=-fanDuctTabThickness) {
    blowerCornerOffset = blower == BL30x10 ? 1 : 0;
    offsetX = blower == BL30x10 ? 1 : 5;
    chimneySizeX = blower_wall_left(blower) + blower_wall_right(blower) + blower_exit(blower) - blowerCornerOffset;
    tabOffsetX = 2.5;

    for (x = [-tabOffsetX, chimneySizeX + tabOffsetX])
        translate([x + offsetX, z, -3])
            rotate([90, 0, 0])
                children();
}

module fanDuct2(blower=BL30x10, jetOffset=[0, 24, -8], chimneySizeZ=14) {
    blowerSize = blower_size(blower);

    exit = blower_exit(blower);
    wallLeft = blower_wall_left(blower);
    wallRight = blower_wall_right(blower);
    base = blower_base(blower);
    top = blower_top(blower);
    blowerCornerOffset = blower == BL30x10 ? 1 : 0; // offset fan duct to account for corner radius of blower

    chimneySize = [exit + wallLeft + wallRight - blowerCornerOffset, blowerSize.z, chimneySizeZ];
    chimneyTopSize = [exit, blowerSize.z - base - top, chimneySize.z + 2];

    module chimney(chimneySize, fillet) {
        rounded_cube_xy(chimneySize, fillet);
        translate([chimneySize.x - exit - wallRight, top, 0])
            rounded_cube_xy(chimneyTopSize, fillet);
    }
    module foot(chimneySize, height, fillet) {
        translate_z(-height)
            difference() {
                hull() {
                    rounded_cube_xy([chimneySize.x, chimneySize.y, height + 2], fillet);
                    translate([0, 11, 0])
                        rounded_cube_xy([chimneySize.x, 5, 3], fillet);
                }
                rotate([0, 90, 0])
                    mirror([1, 0, 0])
                        translate([-eps, -eps, -eps])
                            right_triangle(3, 3, chimneySize.x + 2*eps, center=false);
            }
    }
    module tabs(offsetX, tabThickness=fanDuctTabThickness) {
        tabTopSize = [chimneySize.x + 10.5, tabThickness, 5];
        tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
        difference() {
            hull() {
                translate([(chimneySize.x - tabBottomSize.x)/2, chimneySize.y - tabBottomSize.y, 0])
                    rounded_cube_xy(tabBottomSize, 0.5);
                translate([(chimneySize.x - tabTopSize.x)/2, chimneySize.y - tabTopSize.y, chimneySize.z - tabTopSize.z])
                    rounded_cube_xy(tabTopSize, 0.5);
            }
            translate([-offsetX, chimneySize.y - tabTopSize.y, chimneySize.z])
                fanDuctHolePositions2(blower, 0)
                    hflip()
                        boltHoleM2p5(tabThickness, horizontal=true);
        }

    }
    module jet(offset) {
        jetStartSize = [18, 5, 2];
        jetEndSize = [5, 2, 2];
        translate([chimneySize.x/2, 2, 0])
            hull() {
                translate([-jetStartSize.x/2, 0, 0])
                    cube(jetStartSize);
                translate([-jetEndSize.x/2 + offset.x, offset.y, offset.z])
                    cube(jetEndSize);
            }
    }

    offsetX = blower == BL30x10 ? 1 : 5;
    translate([offsetX, -chimneySize.y, -chimneySize.z])
        difference() {
            fillet = 2;
            union() {
                chimney(chimneySize, fillet);
                foot(chimneySize, height=3, fillet=fillet);
                tabs(offsetX);
            }

            // the flue
            flueInset = [1.5, 1.5, -2*eps];
            flueSize = chimneyTopSize - flueInset;
            translate([chimneySize.x - exit- wallRight + flueInset.x/2, top + flueInset.y/2, -eps])
                rounded_cube_xy(flueSize, 1);

            if (exploded())
                jet(jetOffset);
            else
                #jet(jetOffset); // display jet when not exploded
        }
}


module Fan_Duct_hardware(blower_type=BL30x10) {
    fanDuctHolePositions(blower_type, -fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2p5Caphead(6);
}
