include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../vitamins/bolts.scad>


fanDuctTabThickness = 2;
fanDuctTabOffsetX = 2.5; // if 2.5 or more, no cutout required around bolt heads

module fanDuctHolePositions(blower=BL30x10, z=0) {
    fanDuctHolePositionsWithOffsets(blower, z=z, tabOffsetX=fanDuctTabOffsetX)
        children();
}

module fanDuctHolePositionsWithOffsets(blower=BL30x10, z=0, tabOffsetX=fanDuctTabOffsetX) {
    blowerCornerOffset = blower == BL30x10 ? 1 : 0;
    offsetX = blower == BL30x10 ? 1 : 5;
    chimneySizeX = blower_wall_left(blower) + blower_wall_right(blower) + blower_exit(blower) - blowerCornerOffset;

    for (x = [-tabOffsetX, chimneySizeX + tabOffsetX])
        translate([x + offsetX, z, -3])
            rotate([90, 0, 0])
                children();
}

module fanDuct(blower=BL30x10, jetOffset=[0, 24, -8], chimneySizeZ=14) {
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
                /*rotate([0, 90, 0])
                    mirror([1, 0, 0])
                        translate([-eps, -eps, -eps])
                            right_triangle(3, 3, chimneySize.x + 2*eps, center=false);*/
            }
    }
    module tabs(offsetX, tabThickness, tabOffsetX) {
        tabTopSize = [chimneySize.x + 5.5 + 2*tabOffsetX, tabThickness, 5];
        tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
        hull() {
            translate([(chimneySize.x - tabBottomSize.x)/2, chimneySize.y - tabBottomSize.y, 0])
                rounded_cube_xy(tabBottomSize, 0.5);
            translate([(chimneySize.x - tabTopSize.x)/2, chimneySize.y - tabTopSize.y, chimneySize.z - tabTopSize.z])
                rounded_cube_xy(tabTopSize, 0.5);
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
    tabOffsetX = fanDuctTabOffsetX;
    translate([offsetX, -chimneySize.y, -chimneySize.z])
        difference() {
            fillet = 2;
            union() {
                chimney(chimneySize, fillet);
                foot(chimneySize, height=3, fillet=fillet);
                tabs(offsetX, tabThickness=fanDuctTabThickness, tabOffsetX=tabOffsetX);
            }

            // the flue
            flueInset = [1.5, 1.5, -2*eps];
            flueSize = chimneyTopSize - flueInset;
            translate([chimneySize.x - exit- wallRight + flueInset.x/2, top + flueInset.y/2, -eps])
                rounded_cube_xy(flueSize, 1);

            // the bolt holes
            translate([-offsetX, chimneySize.y - fanDuctTabThickness, chimneySize.z])
                fanDuctHolePositionsWithOffsets(blower, z=0, tabOffsetX=tabOffsetX) {
                    hflip()
                        boltHoleM2p5(fanDuctTabThickness, horizontal=true);
                    // clearance for bolt head
                    cylinder(h=chimneySize.y - fanDuctTabThickness + eps, r=screw_head_radius(M2p5_cap_screw) + 0.25);
                }

            if (exploded())
                jet(jetOffset);
            else
                #jet(jetOffset); // display jet when not exploded
        }
}


module Fan_Duct_hardware(blower_type=BL30x10) {
    fanDuctHolePositions(blower_type, z=-fanDuctTabThickness)
        boltM2p5Caphead(6);
}

