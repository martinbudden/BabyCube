include <../global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>

use <../vitamins/E3DRevo.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 4.5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];

module xCarriageE3DRevoMGN9C(inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth());
    hotendDescriptor = "E3DRevo";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    difference() {
        union() {
            xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            E3DRevoHolder(xCarriageType, size);
        }
        translate([15, 15.5, 20 - revoVoronSizeZ()])
            rotate(90)
                fanDuctHolePositions()
                    rotate([90, 0, 180])
                        boltHoleM2Tap(6);
        xCarriageHotendSideHolePositions(xCarriageType)
            if (inserts) {
                insertHoleM3(size.y, horizontal=true);
            } else {
                boltHoleM3Tap(size.y, horizontal=true);
                boltHoleM3Tap(size.y+3, horizontal=true, chamfer_both_ends=false);
            }
    }
}

module X_Carriage_E3DRevo_MGN9C_stl() {
    stl("X_Carriage_E3DRevo_MGN9C")
        color(pp1_colour)
            xCarriageE3DRevoMGN9C(inserts=false);
}

module E3DRevoHolder(xCarriageType, size) {
    hotendDescriptor = "E3DRevo";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    fan_type = fan25x10;
    fillet = 1;

    translate([size.x/2 - sizeSide.x, 15, 8 - sizeSide.z])
        rotate(90)
            fillet(10, sizeSide.z);

    sizeTop = [size.x, 35, 8];
    difference() {
        translate([size.x/2 - sizeTop.x, 11, 0])
            rounded_cube_yz(sizeTop, fillet);
        translate(hotendOffset)
            revoVoronBoltPositions()
                boltHoleM2p5(sizeTop.z, horizontal=true, rotate=90);
    }

    sizeSide = [3, sizeTop.y, size.z - 12];
    difference() {
        translate([size.x/2 - sizeSide.x, 11, 8 - sizeSide.z])
            rounded_cube_yz(sizeSide, fillet);
        translate([15, 15.5, 20 - revoVoronSizeZ()]) {
            rotate([90, 0, 90]) {
                blower_hole_positions(blower_type)
                    vflip()
                        boltHoleM2Tap(sizeSide.x);
            }
            *rotate(90)
                fanDuctHolePositions()
                    rotate([90, 0, 180])
                        boltHoleM2Tap(sizeSide.x);
        }
    }

    sizeFront = [size.x, 3, 36];
    difference() {
        translate([size.x/2 - sizeFront.x, 37, 8 - sizeFront.z])
            rounded_cube_yz(sizeFront, fillet);
        translate(hotendOffset)
            rotate(-90)
                translate([-17, 0, -14])
                    rotate([0, 90, 0]) {
                        fan_hole_positions(fan_type)
                            boltHoleM3Tap(sizeFront.y, horizontal=true, rotate=180);
                        translate_z(fan_depth(fan_type)/2)
                            boltHole(fan_bore(fan_type), sizeFront.y, horizontal=true, rotate=180);
                    }
    }
}


module X_Carriage_E3DRevo_MGN9C_hardware() {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendDescriptor = "E3DRevo";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    fan_type = fan25x10;

    translate(hotendOffset) {
        rotate(0) {
            rotate(0) {
                revoVoronBoltPositions(8)
                    boltM2p5Caphead(12);
                translate_z(-revoVoronSizeZ())
                    revoVoron();
            }
            rotate(-90)
                translate([-17, 0, -14])
                    rotate([0, -90, 0]) {
                        fan(fan_type);
                        fan_hole_positions(fan_type)
                            boltM3Buttonhead(12);
                    }
        }
    }
    translate([15, 15.5, 20 - revoVoronSizeZ()]) {
        rotate([90, 0, 90]) {
            blower(blower_type);
            blower_hole_positions(blower_type)
                translate_z(blower_lug(blower_type))
                    boltM2Caphead(6);
        }
        rotate(90) {
            stl_colour(pp2_colour)
                E3DRevo_Fan_Duct_stl();
            Fan_Duct_hardware(xCarriageType, hotendDescriptor);
        }
    }
}

module E3DRevo_Fan_Duct_stl() {
    stl("E3DRevo_Fan_Duct")
        color(pp2_colour)
            fanDuct(13);
}

