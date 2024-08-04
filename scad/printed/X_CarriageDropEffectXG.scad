include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/ziptieCutout.scad>

use <../vitamins/DropEffectXG.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];


module xCarriageDropEffectXGMGN9CZipTiePositions(size, hotendOffset) {
    zipTieCutoutSizeY = 5;
    translate([0, hotendOffset.y - 6.5, 10.5 - zipTieCutoutSizeY/2 - 4]) {// needs to clear boltHoles
        translate([-size.x/2, 0, 0])
            rotate([90, 0, -90])
                children();
        translate([size.x/2, 0, 0])
            rotate([90, 0, 90])
                children();
    }
}
module xCarriageDropEffectXGMGN9C(inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth()); // [30, 5, 54]

    hotendDescriptor = "DropEffectXG";
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    fillet = 1;
    extraX = 4; // extend X_Carriage to cover hotend fan

    difference() {
        union() {
            xCarriageDropEffectXGBack(xCarriageType, size, extraX, fillet);
            DropEffectXGHolder(xCarriageType, size, fillet);
        }
        zipTieCutoutSize = [9, 5, 2.25];
        xCarriageDropEffectXGMGN9CZipTiePositions(size, hotendOffset)
            zipTieFullCutout(size=zipTieCutoutSize);

        translate(hotendOffset)
            rotate(90)
                DropEffectXGSideBoltPositions()
                    boltHoleM3Countersunk(size.y, horizontal=true, rotate=180);
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
        translate([0, -railCarriageGap(), 0])
            xCarriageHotendSideHolePositions(xCarriageType)
                if (inserts) {
                    insertHoleM3(size.y, horizontal=true);
                } else {
                    //boltHoleM3Tap(size.y, horizontal=true, rotate=180);
                    boltHoleM3Tap(size.y + 1, horizontal=true, rotate=0, chamfer_both_ends=false);
                }
    }
}

module X_Carriage_DropEffect_XG_MGN9C_stl() {
    stl("X_Carriage_DropEffect_XG_MGN9C")
        color(pp1_colour)
            xCarriageDropEffectXGMGN9C(inserts=false);
}

module DropEffectXGHolder(xCarriageType, size, fillet) {
    hotendDescriptor = "DropEffectXG";
    hotendOffset = printheadHotendOffset(hotendDescriptor);

    sizeTop = [size.x, 35, xCarriageTopThickness() + 0.3];
    difference() {
        translate([-size.x/2, 11, xCarriageTopThickness() - sizeTop.z])
            rounded_cube_yz(sizeTop, fillet);
        translate(hotendOffset) {
            // hole for hotend adaptor
            depth = sizeTop.z + 0.5;
            translate_z(-hotendOffset.z - 0.5)
                boltHole(16.25, depth, horizontal=true, rotate=-90);
            /*DropEffectXGTopBoltPositions(depth)
                rotate([180, 0, -90])
                    boltHoleM2p5Counterbore(depth, boreDepth=2, horizontal=true);*/
        }
    }

    sizeSide = [3, sizeTop.y, size.z - hotendOffset.z - 9];
    translate([-size.x/2, 11, xCarriageTopThickness() - sizeSide.z])
        rounded_cube_yz(sizeSide, fillet);

    sizeBaffle = [6.5, sizeTop.y, 2];
    translate([-size.x/2, 11, hotendOffset.z - 27])
        rounded_cube_yz(sizeBaffle, 0.5);
    // fillet to divert airflow from hotend fan, limited in size to avoid interference with hotend bracket
    translate([-size.x/2 + sizeSide.x, 15, hotendOffset.z - 27 + sizeBaffle.z])
        fillet(4, 27 - hotendOffset.z + fillet);
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
    xCarriageDropEffectXGCableTiePositions(xCarriageType)
    translate([1, railCarriageGap() + 5.4, 0])
        rotate([0, 90, -90])
            cable_tie(cable_r = 3.5, thickness = 5.5);

    xCarriageDropEffectXGMGN9CZipTiePositions(size, hotendOffset)
        rotate(90)
            cable_tie(cable_r = 2.5, thickness = 2.5);

}

module DropEffectXG_Fan_Duct_stl() {
    stl("DropEffectXG_Fan_Duct")
        color(pp2_colour)
            fanDuct(13);
}

module xCarriageDropEffectXGBack(xCarriageType, size, extraX, fillet) {
    /*holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    extraX = 0;
    xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
    */

    sizeX = [size.x + extraX, size.y, size.z];
    carriageSize = carriage_size(xCarriageType);
    topThickness = xCarriageTopThickness();
    baseThickness = xCarriageBaseThickness();

    translate([-size.x/2, carriageSize.y/2, baseThickness]) {
        translate_z(-size.z) {
            rounded_cube_yz(sizeX, fillet);
            // extra extensions for bottom bolts
            rounded_cube_yz([size.x, size.y + 3, baseThickness], fillet);
        }
        // extra extensions for top bolts
        /*translate_z(-topThickness)
            rounded_cube_yz([size.x, size.y + 3, topThickness], fillet);*/
        xCarriageDropEffectXGStrainRelief(carriageSize, size, fillet);
    }
}


module xCarriageDropEffectXGCableTieOffsets(strainReliefSizeX) {
    for (z = [10, 20])
        translate([strainReliefSizeX/2, 0, z])
            children();
}

module xCarriageDropEffectXGCableTiePositions(xCarriageType, strainReliefSizeX=15) {
    xCarriageBackSizeX = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth()).x;
    carriageSize = carriage_size(xCarriageType);

    translate([-xCarriageBackSizeX/2 - 1, carriageSize.y/2, xCarriageBaseThickness()])
        xCarriageDropEffectXGCableTieOffsets(strainReliefSizeX)
            children();
}

module xCarriageDropEffectXGStrainRelief(carriageSize, xCarriageBackSize, fillet) {
    strainReliefSizeX =  15;
    tabSize = [strainReliefSizeX, xCarriageBackSize.y, 27.5 + 2*fillet]; // ensure room for bolt heads

    difference() {
        translate_z(-2*fillet)
            rounded_cube_yz(tabSize, fillet);
        cutoutSize = [2.2, tabSize.y + 2*eps, 4.5];
        xCarriageDropEffectXGCableTieOffsets(strainReliefSizeX)
            for (x = [-4, 4])
                translate([x - cutoutSize.x/2, -eps, -cutoutSize.z/2])
                    rounded_cube_yz(cutoutSize, 0.5);
    }
}

