include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/ziptieCutout.scad>
include <../utils/rounded_cutout.scad>

use <../vitamins/DropEffectXG.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageDropEffectXGSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];
function blowerOffset(hotendDescriptor) = [0, -3, 0]; // -3 is experimental, -2 gives more clearance for blower wire
sideZipTieCutoutSize = [9, 4, 2.25];

module xCarriageDropEffectXG(hotendDescriptor, inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageDropEffectXGSize(xCarriageType, beltWidth()); // [30, 5, 54]
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower = BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);

    fillet = 1;

    difference() {
        union() {
            //xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            xCarriageDropEffectXGBack(xCarriageType, size, fillet);
            DropEffectXGHolder(hotendDescriptor, size, fillet);
        }
        xCarriageDropEffectXGSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
            zipTieFullCutout(size=sideZipTieCutoutSize);

        translate(hotendOffset)
            rotate(90)
                DropEffectXGSideBoltPositions()
                    translate_z(size.y)
                        boltPolyholeM3Countersunk(size.y);
        translate([-size.x/2, hotendOffset.y + blower_width(blower)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8]) {// -27.8 leaves fan duct level with bottom of X_Carriage
            rotate([90, 0, -90])
                blower_hole_positions(blower)
                    vflip()
                        boltHoleM2p5Tap(5, horizontal=true, rotate=90);
            rotate(-90)
                fanDuctHolePositions(blower)
                    rotate([90, 0, 0])
                        vflip()
                            boltHoleM2p5Tap(5, horizontal=true, rotate=90);
        }
        translate([0, -railCarriageGap(), 0])
            xCarriageHotendSideHolePositions(xCarriageType)
                if (inserts) {
                    insertHoleM3(size.y);
                } else {
                    //boltHoleM3Tap(size.y, horizontal=true, rotate=180);
                    boltHoleM3Tap(size.y + 1);
                }
    }
}

module DropEffectXGHolder(hotendDescriptor, size, baseFillet) {
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blowerOffset = blowerOffset(hotendDescriptor);
    fillet = 1;

    carriageSizeY = 20; // carriage_size(MGN9C_carriage), since coordinates are based on center of MGN X carriage
    boltCoverSizeX = 5;

    translate([-size.x/2, carriageSizeY/2, hotendOffset.z]) {
        sizeTop = [size.x, hotendOffset.y + 10 + blowerOffset.y, xCarriageTopThickness() - 1];
        translate_z(xCarriageTopThickness() - sizeTop.z)
            difference() {
                union() {
                    rounded_cube_xz(sizeTop, fillet);
                    // extension for blower bolt holes
                    extensionZ = xCarriageTopThickness() - sizeTop.z + 4;
                    translate_z(-extensionZ)
                        rounded_cube_xz([boltCoverSizeX, sizeTop.y, sizeTop.z + extensionZ], fillet);
                }
                translate([hotendOffset.x + sizeTop.x/2, hotendOffset.y - carriageSizeY/2, 0]) {
                    // hole for hotend adaptor
                    boltHole(17.5, sizeTop.z, horizontal=true, chamfer=0.5);
                }
            }

        sizeSide = [3, sizeTop.y, size.z - 10 - blowerOffset.z];
        translate_z(xCarriageTopThickness() - sizeSide.z) {
            rounded_cube_xz(sizeSide, fillet);
            sizeBoltCover = [boltCoverSizeX, sizeTop.y, 12];
            rounded_cube_xz(sizeBoltCover, fillet);
        }

        sizeBaffle = [6.5, sizeTop.y, 2];
        translate_z(-25) {
            rounded_cube_xz(sizeBaffle, 0.5);
            *translate([0, 12.5, 0])
                rounded_cube_xz([sizeBaffle.x + 1, 14, sizeBaffle.z], 0.5); // extra for bolt cover
            translate_z(-2)
                rounded_cube_xz([sizeBaffle.x, 8, 3], 0.5); // bolt cover
        }
        // fill in gap between back bolt extensions and boltcover
        translate_z(xCarriageTopThickness() - hotendOffset.z - size.z)
            rounded_cube_xz([boltCoverSizeX, 6, 12], baseFillet);
    }
}

module xCarriageDropEffectXG_hardware(hotendDescriptor) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower = BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);
    size = xCarriageDropEffectXGSize(xCarriageType, beltWidth());

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
            not_on_bom()
                DropEffectXGFan();
        }
    }
    translate([-size.x/2, hotendOffset.y + blower_width(blower)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8]) {// -27.8 leaves fan duct level with bottom of X_Carriage
        rotate([90, 0, -90]) {
            explode(40, true, show_line=false) {
                blower(blower);
                blower_hole_positions(blower)
                    translate_z(blower_lug(blower))
                        boltM2p5Caphead(6);
            }
        }
        rotate(-90)
            explode([0, -40, -10], true) {
                stl_colour(pp2_colour)
                    DropEffectXG_Fan_Duct_stl();
                Fan_Duct_hardware(blower);
        }
    }
    xCarriageDropEffectXGStrainReliefCableTiePositions(xCarriageType)
        translate([1, railCarriageGap() + 5.4, 0])
            rotate([0, 90, -90])
                if (!exploded())
                    cable_tie(cable_r = 3.5, thickness = 5.0);

    xCarriageDropEffectXGSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
        rotate(90)
            if (!exploded())
                cable_tie(cable_r = 2.5, thickness = 2.5);
    translate([size.x/4, 14, 11.5])
        rotate([90, 0, 0])
            if (!exploded())
                cable_tie(cable_r = 2.5, thickness = 4);
}

module xCarriageDropEffectXGBack(xCarriageType, size, fillet) {
    /*holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    extraX = 0;
    xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
    */

    sizeX = [size.x, size.y, size.z + 4];
    carriageSize = carriage_size(xCarriageType);
    topThickness = xCarriageTopThickness();
    baseThickness = xCarriageBaseThickness();

    translate([-size.x/2, carriageSize.y/2, topThickness - size.z]) {
        difference() {
            rounded_cube_xz(sizeX, fillet);
            // hotend fan exhaust outlet
            translate([3, -eps, baseThickness + 13.5])
                rounded_cube_xz([9, size.y + 2*eps, 16], 1);
            // ziptie cutout
            translate([size.x - 4, -eps, 25])
                rounded_cube_xz([2, size.y + 2*eps, 4.5], 0.5);
            // top ziptie cutout
            translate([3*size.x/4 - 4.5/2, -eps, size.z])
                rounded_cube_xz([4.5, size.y + 2*eps, 1.5], 0.5);
        }
        // extra extensions for bottom bolts
        rounded_cube_xz([size.x, size.y + 1, baseThickness], fillet);
        // extra extensions for top bolts
        /*translate_z(-topThickness)
            rounded_cube_xz([size.x, size.y + 2, topThickness], fillet);*/
        xCarriageDropEffectXGStrainRelief(carriageSize, size, fillet);
    }
}

module xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX) {
    for (z = [10, 20, 30])
       translate([strainReliefSizeX/2, 0, z])
            children();
}

module xCarriageDropEffectXGStrainReliefCableTiePositions(xCarriageType, strainReliefSizeX=16) {
    xCarriageBackSizeX = xCarriageDropEffectXGSize(xCarriageType, beltWidth()).x;
    carriageSize = carriage_size(xCarriageType);

    translate([-xCarriageBackSizeX/2 - 1, carriageSize.y/2, xCarriageBaseThickness()])
        xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX)
            children();
}

module xCarriageDropEffectXGStrainRelief(carriageSize, xCarriageBackSize, fillet) {
    strainReliefSizeX =  16;
    tabSize = [strainReliefSizeX, xCarriageBackSize.y, 27.5 + 10+ 2*fillet]; // ensure room for bolt heads

    translate_z(xCarriageBackSize.z)
        difference() {
            translate_z(-2*fillet)
                rounded_cube_xz(tabSize, fillet);
            cutoutSize = [2.5, tabSize.y + 2*eps, 4.5];
            xCarriageDropEffectXGStrainReliefCableTieOffsets(strainReliefSizeX)
                for (x = [-4, 4])
                    translate([x - cutoutSize.x/2, -eps, -cutoutSize.z/2])
                        rounded_cube_xz(cutoutSize, 1);
        }
}

module xCarriageDropEffectXGSideZipTiePositions(size, hotendOffset, zipTieCutoutSizeY) {
    translate([0, hotendOffset.y, hotendOffset.z + 10.5 - zipTieCutoutSizeY/2 - 4]) {// needs to clear boltHoles
        // blower side
        translate([-size.x/2, -8, 0])
            rotate([90, 0, -90])
                children();
    }
}


module X_Carriage_DropEffect_XG_stl() {
    stl("X_Carriage_DropEffect_XG")
        color(pp4_colour)
            rotate([90, 0, 0])
                xCarriageDropEffectXG("DropEffectXG", inserts=false);
}

module X_Carriage_DropEffect_XG_hardware() {
    xCarriageDropEffectXG_hardware("DropEffectXG");
}

module DropEffectXG_Fan_Duct_stl() {
    stl("DropEffectXG_Fan_Duct")
        color(pp2_colour)
            fanDuct(BL30x10, 14);
}

