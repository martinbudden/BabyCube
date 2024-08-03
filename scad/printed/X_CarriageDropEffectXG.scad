include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>

use <../vitamins/DropEffectXG.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 4.5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];


module xCarriageDropEffectXGMGN9C(inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth());
    hotendDescriptor = "DropEffectXG";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    extraX = 0;
    blower_type = BL30x10;

    difference() {
        union() {
            xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            DropEffectXGHolder(xCarriageType, size);
        }
        translate(hotendOffset)
            rotate(90)
                DropEffectXGSideBoltPositions()
                    boltHoleM3Countersunk(size.y, horizontal=true);
        translate([-size.x/2, 42, hotendOffset.z - dropEffectXGSizeZ() + 20]) {
            rotate([90, 0, -90])
                blower_hole_positions(blower_type)
                    vflip()
                        boltHoleM2Tap(5);
            translate([0, 15.5-42, 0])
                rotate(90)
                    fanDuctHolePositions()
                        rotate([90, 0, 0])
                            boltHoleM2Tap(6);
        }
        xCarriageHotendSideHolePositions(xCarriageType)
            if (inserts) {
                insertHoleM3(size.y, horizontal=true);
            } else {
                boltHoleM3Tap(size.y, horizontal=true);
                boltHoleM3Tap(size.y+3, horizontal=true, chamfer_both_ends=false);
            }
    }
}

module X_Carriage_DropEffect_XG_MGN9C_stl() {
    stl("X_Carriage_DropEffect_XG_MGN9C")
        color(pp1_colour)
            xCarriageDropEffectXGMGN9C(inserts=false);
}

module DropEffectXGHolder(xCarriageType, size) {
    hotendDescriptor = "DropEffectXG";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    fan_type = fan25x10;
    fillet = 1;


    sizeTop = [size.x, 35, 8.3];
    difference() {
        translate([size.x/2 - sizeTop.x, 11, 8 - sizeTop.z])
            rounded_cube_yz(sizeTop, fillet);
        translate(hotendOffset) {
            depth = sizeTop.z + 0.5;
            translate_z(-hotendOffset.z - 0.5)
                boltHole(16.25, depth, horizontal=true, rotate=-90);
            *DropEffectXGTopBoltPositions(depth)
                rotate([180, 0, -90])
                    boltHoleM2p5Counterbore(depth, boreDepth=2, horizontal=true);
        }
    }

    sizeSide = [3, sizeTop.y, size.z + hotendOffset.z - 4];
    difference() {
        translate([-size.x/2, 11, 8 - sizeSide.z])
            union() {
                rounded_cube_yz(sizeSide, fillet);
                translate([sizeSide.x, 4, 0])
                    fillet(10, sizeSide.z);
            }
    }
}

module X_Carriage_DropEffect_XG_MGN9C_hardware() {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendDescriptor = "DropEffectXG";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    fan_type = fan25x10;

    size = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth());
    translate(hotendOffset)
        rotate(90)
            DropEffectXGSideBoltPositions()
                translate_z(size.y)
                    boltM3Countersunk(8);

    translate(hotendOffset) {
        /*DropEffectXGTopBoltPositions(8 - 2)
            boltM2p5Caphead(10);*/
        rotate(90)
            DropEffectXG();
        rotate(180)
            translate([-13, 0, -15])
                rotate([0, -90, 0]) {
                    explode(40)
                        not_on_bom() fan(fan_type);
                    explode(40, true)
                        fan_hole_positions(fan_type)
                            not_on_bom() boltM2p5Buttonhead(12);
                }
    }

    translate([-15, 42, hotendOffset.z - dropEffectXGSizeZ() + 20]) {
        rotate([90, 0, -90]) {
            explode(40, true, show_line=false) {
                blower(blower_type);
                blower_hole_positions(blower_type)
                    translate_z(blower_lug(blower_type))
                        boltM2Caphead(6);
            }
        }
        explode([40, 0,-20], true)
            rotate(-90) {
                stl_colour(pp2_colour)
                    DropEffectXG_Fan_Duct_stl();
                Fan_Duct_hardware(xCarriageType, hotendDescriptor);
        }
    }
}

module DropEffectXG_Fan_Duct_stl() {
    stl("DropEffectXG_Fan_Duct")
        color(pp2_colour)
            fanDuct(13);
}

