include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/zipties.scad>
use <NopSCADlib/vitamins/e3d.scad> // for bowden_connector
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/ziptieCutout.scad>
include <../utils/rounded_cutout.scad>

use <../vitamins/E3DRevo.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageE3DRevoSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];
function blowerOffset(hotendDescriptor) = hotendDescriptor == "E3DRevoCompact" ? [0, -2.5, -1] : [0, -2, -4];
sideZipTieCutoutSize = [8, 3.5, 2];

module xCarriageE3DRevo(hotendDescriptor, inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageE3DRevoSize(xCarriageType, beltWidth()); // [30, 5, 54]
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower = hotendDescriptor == "E3DRevo40" ? BL40x10 : BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);

    fillet = 1;

    difference() {
        union() {
            //xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            xCarriageE3DRevoBack(xCarriageType, hotendDescriptor, size, fillet);
            E3DRevoHolder(hotendDescriptor, size, blowerOffset, fillet);
        }
        xCarriageE3DRevoSideZipTiePositions(size, hotendOffset, blowerOffset, sideZipTieCutoutSize.y)
            zipTieFullCutout(size=sideZipTieCutoutSize);
        translate([-size.x/2, hotendOffset.y + blower_width(blower)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8])// -27.8 leaves fan duct level with bottom of X_Carriage
            rotate(-90) {
                rotate([90, 0, 0])
                    blower_hole_positions(blower)
                        vflip()
                            boltHoleM2p5Tap(5);
                fanDuctHolePositions(blower)
                    vflip()
                        boltHoleM2p5Tap(5);
            }
        translate([0, -railCarriageGap(), 0])
            xCarriageHotendSideHolePositions(xCarriageType)
                if (inserts) {
                    insertHoleM3(size.y + 2, horizontal=true, rotate=180);
                } else {
                    //boltHoleM3Tap(size.y, horizontal=true, rotate=180);
                    boltHoleM3Tap(size.y + 2, horizontal=true, rotate=180, chamfer_both_ends=false);
                }
    }
}

module E3DRevoHolder(hotendDescriptor, size, blowerOffset, baseFillet) {
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    fillet = 1;

    carriageSizeY = 20; // carriage_size(MGN9C_carriage), since coordinates are based on center of MGN X carriage
    fan = fan25x10;

    translate([-size.x/2, carriageSizeY/2, hotendOffset.z]) {
        sizeTop = [size.x, hotendOffset.y + 10 + blowerOffset.y, xCarriageTopThickness()];
        difference() {
            union() {
                rounded_cube_yz(sizeTop, fillet);
                if (hotendDescriptor == "E3DRevo40")
                    rounded_cube_yz([7, sizeTop.y, sizeTop.z + 3], fillet);
            }
            translate([hotendOffset.x + size.x/2, hotendOffset.y - carriageSizeY/2, 0]) {
                // hole for Bowden connector
                boltHole(M6_tap_radius*2, sizeTop.z, horizontal=true, rotate=-90, chamfer=0.5);
                revoVoronBoltPositions(sizeTop.z)
                    rotate([180, 0, 90])
                        boltHoleM2p5Counterbore(sizeTop.z, boreDepth=2, horizontal=true);
            }
        }

        sizeSide = [3, sizeTop.y, size.z - 11 - blowerOffset.z];
        translate_z(xCarriageTopThickness() - sizeSide.z) {
            rounded_cube_yz(sizeSide, fillet);
        }

        if (hotendDescriptor != "E3DRevoCompact") {
            sizeFront = [size.x, 3, 34];
            difference() {
                indentY = 3;
                translate([size.x - sizeFront.x, sizeTop.y + 2+1 - carriageSizeY/2, sizeTop.z - sizeFront.z]) {
                    rounded_cube_yz(sizeFront, 0.5);
                    // baffle for fan exhaust
                    translate([0, -indentY, 0]) {
                        rounded_cube_yz([sizeFront.x, sizeFront.y + indentY, 2], 0.5);
                        fillet = 5;
                        cube([sizeBaffle.x + fillet, 2, 2]);
                        translate([sizeBaffle.x, 0, 0])
                            rotate(-90)
                                fillet(fillet, 2);
                    }
                }
                translate([hotendOffset.x + size.x/2, hotendOffset.y - carriageSizeY/2 + 1, 0])
                    rotate(-90)
                        translate([-18, 0, -13])
                            rotate([0, 90, 0]) {
                                fan_hole_positions(fan)
                                    boltHoleM3Tap(sizeFront.y, horizontal=true);
                                translate_z(fan_depth(fan)/2)
                                    boltHole(fan_bore(fan) - 1, sizeFront.y + indentY, horizontal=true, chamfer=0.5);
                            }
            }

            sizeBaffle = [7, sizeTop.y - 7, 2];
            translate_z(-26) {
                rounded_cube_yz(sizeBaffle, 0.5);
                rounded_cube_yz([sizeTop.x, 10, sizeBaffle.z], 0.5);
                fillet = 5;
                cube([sizeBaffle.x + fillet, 10, sizeBaffle.z]);
                translate([sizeBaffle.x, 10, 0])
                    fillet(fillet, sizeBaffle.z);
            }

            translate([sizeSide.x, 5, sizeTop.z - sizeSide.z])
                fillet(10, sizeSide.z);
        }
    }
}

module xCarriageE3DRevo_hardware(hotendDescriptor, blowerOffset) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower = hotendDescriptor == "E3DRevo40" ? BL40x10 : BL30x10;
    fan = fan25x10;
    size = xCarriageE3DRevoSize(xCarriageType, beltWidth());

    translate(hotendOffset) {
        rotate(0) {
            revoVoronBoltPositions(xCarriageTopThickness() - 2)
                boltM2p5Caphead(10);
            translate_z(-revoVoronSizeZ())
                explode(-80)
                    E3DRevoVoron();
            vitamin(str(": Bowden connector"));
            explode(40)
                translate_z(xCarriageTopThickness())
                    bowden_connector();
        }
        indent = 2;
        rotate(-90)
            translate([hotendDescriptor == "E3DRevoCompact" ? hotendOffset.y - 20 + indent : -18, 0, -13])
                rotate([0, -90, 0]) {
                    explode(40, true, show_line=false) {
                        fan(fan);
                        fan_hole_positions(fan)
                            boltM3Buttonhead(12);
                    }
                }
    }
    translate([-size.x/2, hotendOffset.y + blower_width(blower)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8])// -27.8 leaves fan duct level with bottom of X_Carriage
        rotate(-90) {
            rotate([90, 0, 0])
                explode(40, true, show_line=false) {
                    blower(blower);
                    blower_hole_positions(blower)
                        translate_z(blower_lug(blower))
                            boltM2p5Caphead(6);
                }
            explode([0, -40, -10], true) {
                stl_colour(pp2_colour)
                    if (hotendDescriptor == "E3DRevo40")
                        E3DRevo_Fan_Duct_40_stl();
                    else
                        E3DRevo_Fan_Duct_stl();
                Fan_Duct_hardware(blower);
            }
        }
    xCarriageE3DRevoStrainReliefCableTiePositions(xCarriageType)
        translate([1, railCarriageGap() + 2.0, 0])
            if (!exploded())
                ziptie(small_ziptie, r=3.5, t=5.0);

    xCarriageE3DRevoSideZipTiePositions(size, hotendOffset, blowerOffset, sideZipTieCutoutSize.y)
        translate_z(2.5)
            rotate([90, 180, 0])
                if (!exploded())
                    ziptie(small_ziptie, r=2.5, t=2.5);
}

module xCarriageE3DRevoBack(xCarriageType, hotendDescriptor, size, fillet) {
    /*holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    extraX = 0;
    xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
    */

    extraX = 4; // extend X_Carriage to cover hotend fan
    sizeX = [size.x + extraX, size.y, size.z];
    carriageSize = carriage_size(xCarriageType);
    topThickness = xCarriageTopThickness();
    baseThickness = xCarriageBaseThickness();
    hotendOffset = printheadHotendOffset(hotendDescriptor);

    translate([-size.x/2, carriageSize.y/2, topThickness - size.z]) {
        difference() {
            rounded_cube_yz(sizeX, fillet);
            if (hotendDescriptor == "E3DRevoCompact") {
                fan = fan25x10;
                translate([size.x/2 + hotendOffset.x, 0, size.z - 22])
                    rotate([90, 0, 180]) {
                        offset = 3;
                        translate_z(offset)
                            rounded_cube_xy([fan_width(fan) + 0.5, fan_width(fan) + 0.5, size.y - offset + eps], 0.5, xy_center=true);
                        boltHole(fan_bore(fan) - 0.5, size.y);
                        fan_hole_positions(fan)
                            vflip()
                                boltHoleM3Tap(size.y);
                    }
            }
        }
        // extra extensions for bottom bolts
        rounded_cube_yz([size.x, size.y + 1, baseThickness], fillet);
        // extra extensions for top bolts
        translate_z(size.z - topThickness)
            rounded_cube_yz([size.x, size.y + 2, topThickness], fillet);
        xCarriageE3DRevoStrainRelief(carriageSize, size, fillet);
    }
}

module xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX) {
    for (z = [10, 20, 30])
        translate([strainReliefSizeX/2, 0, z])
            children();
}

module xCarriageE3DRevoStrainReliefCableTiePositions(xCarriageType, strainReliefSizeX=16) {
    xCarriageBackSizeX = xCarriageE3DRevoSize(xCarriageType, beltWidth()).x;
    carriageSize = carriage_size(xCarriageType);

    translate([-xCarriageBackSizeX/2 - 1, carriageSize.y/2, xCarriageBaseThickness()])
        xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX)
            children();
}

module xCarriageE3DRevoStrainRelief(carriageSize, xCarriageBackSize, fillet) {
    strainReliefSizeX =  16;
    tabSize = [strainReliefSizeX, xCarriageBackSize.y, 27.5 + 10 + 2*fillet]; // ensure room for bolt heads

    translate_z(xCarriageBackSize.z)
        difference() {
            translate_z(-2*fillet)
                rounded_cube_yz(tabSize, fillet);
            cutoutSize = [2.5, tabSize.y + 2*eps, 4.5];
            xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX)
                for (x = [-4, 4])
                    translate([x - cutoutSize.x/2, -eps, -cutoutSize.z/2])
                        rounded_cutout_yz(cutoutSize, 1);
        }
}

module xCarriageE3DRevoSideZipTiePositions(size, hotendOffset, blowerOffset, zipTieCutoutSizeY) {
    translate([0, hotendOffset.y, hotendOffset.z + 10.5 - zipTieCutoutSizeY/2 - 4]) {// needs to clear boltHoles
        // blower side
        translate([-size.x/2, -8, blowerOffset.z])
            rotate([90, 0, -90])
                children();
        // hotend fan side
        translate([size.x/2, -6.5, 0])
            rotate([90, 0, 90])
                children();
    }
}


module X_Carriage_E3DRevo_stl() {
    stl("X_Carriage_E3DRevo")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevo("E3DRevo", inserts=false);
}

module X_Carriage_E3DRevo_hardware() {
    xCarriageE3DRevo_hardware("E3DRevo", blowerOffset());
}

module X_Carriage_E3DRevo_Compact_stl() {
    stl("X_Carriage_E3DRevo_Compact")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevo("E3DRevoCompact", inserts=false);
}

module X_Carriage_E3DRevo_Compact_hardware() {
    xCarriageE3DRevo_hardware("E3DRevoCompact");
}

module X_Carriage_E3DRevo_40_stl() {
    stl("X_Carriage_E3DRevo")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevo("E3DRevo40", inserts=false);
}

module X_Carriage_E3DRevo_40_hardware() {
    xCarriageE3DRevo_hardware("E3DRevo40");
}

module E3DRevo_Fan_Duct_stl() {
    stl("E3DRevo_Fan_Duct")
        color(pp2_colour)
            fanDuct(blower=BL30x10, jetOffset=[0, 24, -8], chimneySizeZ=15 + blowerOffset().z);
}

module E3DRevo_Fan_Duct_40_stl() {
    stl("E3DRevo_Fan_Duct_40")
        color(pp2_colour)
            fanDuct(BL40x10, 16);
}

