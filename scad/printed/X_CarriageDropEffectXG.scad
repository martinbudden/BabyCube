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
function blowerOffset(hotendDescriptor) = [0, -3, 0]; // -3 is experimental, -2 gives more clearance for blower wire
sideZipTieCutoutSize = [9, 4, 2.25];

module xCarriageDropEffectXGMGN9CSideZipTiePositions(size, hotendOffset, zipTieCutoutSizeY) {
    translate([0, hotendOffset.y, hotendOffset.z + 10.5 - zipTieCutoutSizeY/2 - 4]) {// needs to clear boltHoles
        // blower side
        translate([-size.x/2, -8, 0])
            rotate([90, 0, -90])
                children();
        // hotend fan side
        translate([size.x/2, -8, 0])
            rotate([90, 0, 90])
                children();
    }
}

module xCarriageDropEffectXGMGN9C(hotendDescriptor, inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth()); // [30, 5, 54]
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);

    fillet = 1;
    extraX = 0; // no extension, it gets in the way of the heater cartridge wires

    difference() {
        union() {
            //xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            xCarriageDropEffectXGBack(xCarriageType, size, extraX, fillet);
            translate_z(hotendOffset.z)
                DropEffectXGHolder(hotendDescriptor, size, fillet);
        }
        xCarriageDropEffectXGMGN9CSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
            zipTieFullCutout(size=sideZipTieCutoutSize);

        translate(hotendOffset)
            rotate(90)
                DropEffectXGSideBoltPositions()
                    boltHoleM3Countersunk(size.y, horizontal=true, rotate=180);
        translate([-size.x/2, hotendOffset.y + blower_width(blower_type)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8]) {// -27.8 leaves fan duct level with bottom of X_Carriage
            rotate([90, 0, -90])
                blower_hole_positions(blower_type)
                    vflip()
                        rotate(-30)
                            boltHoleM2p5Tap(5);
            rotate(-90)
                fanDuctHolePositions(blower_type)
                    rotate([90, 0, 0])
                        vflip()
                            boltHoleM2p5Tap(5);
        }
        translate([0, -railCarriageGap(), 0])
            xCarriageHotendSideHolePositions(xCarriageType)
                if (inserts) {
                    insertHoleM3(size.y, horizontal=true, rotate=180);
                } else {
                    //boltHoleM3Tap(size.y, horizontal=true, rotate=180);
                    boltHoleM3Tap(size.y + 1, horizontal=true, rotate=180, chamfer_both_ends=false);
                }
    }
}

module DropEffectXGHolder(hotendDescriptor, size, fillet) {
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blowerOffset = blowerOffset(hotendDescriptor);

    carriageSizeY = 20; // carriage_size(MGN9C_carriage), since coordinates are based on center of MGN X carriage
    boltCoverSizeX = 5;

    sizeTop = [size.x, hotendOffset.y + 9 + blowerOffset.y, xCarriageTopThickness() - 1];
    translate([-sizeTop.x/2, carriageSizeY/2, 0]) {
        translate_z(xCarriageTopThickness() - sizeTop.z)
            difference() {
                union() {
                    rounded_cube_yz(sizeTop, fillet);
                    // extension for blower bolt holes
                    extensionZ = xCarriageTopThickness() - sizeTop.z + 4;
                    translate_z(-extensionZ)
                        rounded_cube_yz([boltCoverSizeX, sizeTop.y, sizeTop.z + extensionZ], fillet);
                }
                translate([hotendOffset.x + sizeTop.x/2, hotendOffset.y - carriageSizeY/2, 0]) {
                    // hole for hotend adaptor
                    boltHole(17.5, sizeTop.z, horizontal=true, rotate=-90, chamfer=0.5);
                    /*DropEffectXGTopBoltPositions(sizeTop.z)
                        rotate([180, 0, -90])
                            boltHoleM2p5Counterbore(sizeTop.z, boreDepth=2, horizontal=true);
                    */
                }
            }

        sizeSide = [3, sizeTop.y, size.z - 10 - blowerOffset.z];
        translate_z(xCarriageTopThickness() - sizeSide.z) {
            rounded_cube_yz(sizeSide, fillet);
            sizeBoltCover = [boltCoverSizeX, sizeTop.y, 11];
            rounded_cube_yz(sizeBoltCover, fillet);
        }

        sizeBaffle = [6.5, sizeTop.y, 2];
        translate_z(-27) {
            rounded_cube_yz(sizeBaffle, 0.5);
            *translate([0, 12.5, 0])
                rounded_cube_yz([sizeBaffle.x + 1, 14, sizeBaffle.z], 0.5); // extra for bolt cover
            rounded_cube_yz([sizeBaffle.x, 8, 5], 1); // bolt cover
        }
        // fill in gap between back bolt extensions and boltcover
        translate_z(xCarriageTopThickness() - hotendOffset.z - size.z)
            rounded_cube_yz([boltCoverSizeX, 6, 10], fillet);
    }
}

module xCarriageDropEffectXGMGN9C_hardware(hotendDescriptor) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);
    fan_type = fan25x10;
    size = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth());

    translate(hotendOffset) {
        rotate(90) {
            /*DropEffectXGTopBoltPositions(xCarriageTopThickness() - 2)
                boltM2p5Caphead(10);
            */
            DropEffectXGSideBoltPositions()
                translate_z(size.y)
                    explode(50)
                        boltM3Countersunk(8);
            explode(-50)
                DropEffectXG();
        }
        rotate(180)
            translate([-13, 0, -15])
                rotate([0, -90, 0]) {
                    explode([-50, 0, 20], true, show_line=false) {
                        not_on_bom() fan(fan_type);
                        fan_hole_positions(fan_type)
                            not_on_bom() boltM2p5Buttonhead(12);
                    }
                }
    }
    translate([-size.x/2, hotendOffset.y + blower_width(blower_type)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8]) {// -27.8 leaves fan duct level with bottom of X_Carriage
        rotate([90, 0, -90]) {
            explode(40, true, show_line=false) {
                blower(blower_type);
                blower_hole_positions(blower_type)
                    translate_z(blower_lug(blower_type))
                        boltM2p5Caphead(6);
            }
        }
        rotate(-90)
            explode([0, -40, -10], true) {
                stl_colour(pp2_colour)
                    DropEffectXG_Fan_Duct_stl();
                Fan_Duct_hardware(blower_type);
        }
    }
    xCarriageDropEffectXGStrainReliefCableTiePositions(xCarriageType)
        translate([1, railCarriageGap() + 5.4, 0])
            rotate([0, 90, -90])
                if (!exploded())
                    cable_tie(cable_r = 3.5, thickness = 5.0);

    xCarriageDropEffectXGMGN9CSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
        rotate(90)
            if (!exploded())
                cable_tie(cable_r = 2.5, thickness = 2.5);
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

    translate([-size.x/2, carriageSize.y/2, topThickness]) {
        translate_z(-size.z) {
            difference() {
                rounded_cube_yz(sizeX, fillet);
                // hotend fan exhaust outlet
                translate([3, 0, baseThickness + 14.5])
                    roundedCutoutYZ([8, size.y, 15], 1);
                translate([size.x - 4, -eps, 25]) {
                    roundedCutoutYZ([1.5, size.y, 4.5], 1);
                }
            }
            // extra extensions for bottom bolts
            rounded_cube_yz([size.x, size.y + 1, baseThickness], fillet);
        }
        // extra extensions for top bolts
        /*translate_z(-topThickness)
            rounded_cube_yz([size.x, size.y + 2, topThickness], fillet);*/
        xCarriageDropEffectXGStrainRelief(carriageSize, size, fillet);
    }
}

module roundedCutoutYZ(size, fillet) {
    translate([0, -eps, 0])
        cube([size.x, size.y + 2*eps, size.z]);
    rotate([0, 90, 0])
        fillet(fillet, size.x);
    translate([0, size.y, 0])
        rotate([90, 180, 90])
            fillet(fillet, size.x);
    translate([0, size.y, size.z])
        rotate([90, -90, 90])
            fillet(fillet, size.x);
    translate([0, 0, size.z])
        rotate([90, 0, 90])
            fillet(fillet, size.x);
}

module xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX) {
    for (z = [10, 20])
        translate([strainReliefSizeX/2, 0, z])
            children();
}

module xCarriageDropEffectXGStrainReliefCableTiePositions(xCarriageType, strainReliefSizeX=15) {
    xCarriageBackSizeX = xCarriageHotendSideDropEffectXGSize(xCarriageType, beltWidth()).x;
    carriageSize = carriage_size(xCarriageType);

    translate([-xCarriageBackSizeX/2 - 1, carriageSize.y/2, xCarriageBaseThickness()])
        xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX)
            children();
}

module xCarriageDropEffectXGStrainRelief(carriageSize, xCarriageBackSize, fillet) {
    strainReliefSizeX =  15;
    tabSize = [strainReliefSizeX, xCarriageBackSize.y, 27.5 + 2*fillet]; // ensure room for bolt heads

    difference() {
        translate_z(-2*fillet)
            rounded_cube_yz(tabSize, fillet);
        cutoutSize = [2.2, tabSize.y + 2*eps, 4.5];
        xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX)
            for (x = [-4, 4])
                translate([x - cutoutSize.x/2, -eps, -cutoutSize.z/2])
                    roundedCutoutYZ(cutoutSize, 1);
    }
}

module DropEffectXG_Fan_Duct_stl() {
    stl("DropEffectXG_Fan_Duct")
        color(pp2_colour)
            fanDuct(BL30x10, 14);
}

module X_Carriage_DropEffect_XG_MGN9C_stl() {
    stl("X_Carriage_DropEffect_XG_MGN9C")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageDropEffectXGMGN9C("DropEffectXG", inserts=false);
}

module X_Carriage_DropEffect_XG_MGN9C_hardware() {
    xCarriageDropEffectXGMGN9C_hardware("DropEffectXG");
}

