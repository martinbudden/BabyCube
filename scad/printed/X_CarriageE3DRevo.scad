include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/fans.scad>
use <NopSCADlib/vitamins/e3d.scad> // for bowden_connector
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/ziptieCutout.scad>

use <../vitamins/E3DRevo.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];
function blowerOffset(hotendDescriptor) = hotendDescriptor == "E3DRevoCompact" ? [0, -2.5, -1] : [0, -2, -1];
sideZipTieCutoutSize = [9, 4, 2.25];

module xCarriageE3DRevoMGN9CSideZipTiePositions(size, hotendOffset, zipTieCutoutSizeY) {
    echo(he=hotendOffset);
    echo(z=zipTieCutoutSizeY);
    translate([0, hotendOffset.y, hotendOffset.z + 10.5 - zipTieCutoutSizeY/2 - 4]) {// needs to clear boltHoles
        //blower side
        translate([-size.x/2, -10, 0])
            rotate([90, 0, -90])
                children();
        // hotend fan side
        translate([size.x/2, -6.5, 0])
            rotate([90, 0, 90])
                children();
    }
}

module xCarriageE3DRevoMGN9C(hotendDescriptor, inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth());
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = hotendDescriptor == "E3DRevo40" ? BL40x10 : BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);

    fillet = 1;
    extraX = 4; // extend X_Carriage to cover hotend fan

    difference() {
        union() {
            //xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
            xCarriageE3DRevoBack(xCarriageType, hotendDescriptor, size, extraX, fillet);
            translate_z(hotendOffset.z)
                E3DRevoHolder(hotendDescriptor, size, fillet);
        }
        xCarriageE3DRevoMGN9CSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
            zipTieFullCutout(size=sideZipTieCutoutSize);
        translate([-size.x/2, hotendOffset.y + blower_width(blower_type)/2 + blowerOffset.y, hotendOffset.z + blowerOffset.z - 27.8]) {// -27.8 leaves fan duct level with bottom of X_Carriage
           rotate([90, 0, -90])
                blower_hole_positions(blower_type)
                    vflip()
                        boltHoleM2p5Tap(7);
                rotate(-90)
                    fanDuctHolePositions(blower_type)
                        rotate([90, 0, 0])
                            vflip()
                                boltHoleM2p5Tap(7);
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

module E3DRevoHolder(hotendDescriptor, size, fillet) {
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blowerOffset = blowerOffset(hotendDescriptor);
    fan_type = fan25x10;

    sizeTop = [size.x, hotendOffset.y + 9 + blowerOffset.y, xCarriageTopThickness()];
    difference() {
        translate([-size.x/2, 10, 0]) {
            rounded_cube_yz(sizeTop, fillet);
            if (hotendDescriptor == "E3DRevo40")
                rounded_cube_yz([7, sizeTop.y, sizeTop.z + 3], fillet);
        }
        translate([hotendOffset.x, hotendOffset.y, 0]) {
            // hole for Bowden connector
            boltHole(M6_tap_radius*2, sizeTop.z, horizontal=true, rotate=-90, chamfer=0.5);
            revoVoronBoltPositions(sizeTop.z)
                rotate([180, 0, 90])
                    boltHoleM2p5Counterbore(sizeTop.z, boreDepth=2, horizontal=true);
        }
    }

    sizeSide = [3, sizeTop.y, size.z - 10 - blowerOffset.z];
    translate([-size.x/2, 10, xCarriageTopThickness() - sizeSide.z])
        rounded_cube_yz(sizeSide, fillet);

    if (hotendDescriptor != "E3DRevoCompact") {
        sizeFront = [size.x, 3, 34];
        difference() {
            indentY = 3;
            translate([size.x/2 - sizeFront.x, sizeTop.y + 2+1, sizeTop.z - sizeFront.z]) {
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
            translate([hotendOffset.x, hotendOffset.y + 1, 0])
                rotate(-90)
                    translate([-18, 0, -13])
                        rotate([0, 90, 0]) {
                            fan_hole_positions(fan_type)
                                boltHoleM3Tap(sizeFront.y, horizontal=true);
                            translate_z(fan_depth(fan_type)/2)
                                boltHole(fan_bore(fan_type), sizeFront.y + indentY, horizontal=true, chamfer=0.5);
                        }
        }

        sizeBaffle = [7, sizeTop.y - 7, 2];
        translate([-size.x/2, 10, -26]) {
            rounded_cube_yz(sizeBaffle, 0.5);
            rounded_cube_yz([sizeTop.x, 10, sizeBaffle.z], 0.5);
            fillet = 5;
            cube([sizeBaffle.x + fillet, 10, sizeBaffle.z]);
            translate([sizeBaffle.x, 10, 0])
                fillet(fillet, sizeBaffle.z);
        }

        translate([-size.x/2 + sizeSide.x, 15, sizeTop.z - sizeSide.z])
            fillet(10, sizeSide.z);
    }
}

module xCarriageE3DRevoMGN9C_hardware(hotendDescriptor) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    hotendOffset = printheadHotendOffset(hotendDescriptor);
    blower_type = hotendDescriptor == "E3DRevo40" ? BL40x10 : BL30x10;
    blowerOffset = blowerOffset(hotendDescriptor);
    fan_type = fan25x10;
    size = xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth());

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
            translate([hotendDescriptor == "E3DRevoCompact" ? hotendOffset.y - 20 + indent : -19, 0, -13])
                rotate([0, -90, 0]) {
                    explode(40, true, show_line=false) {
                        fan(fan_type);
                        fan_hole_positions(fan_type)
                            boltM3Buttonhead(12);
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
                    if (hotendDescriptor == "E3DRevo40")
                        E3DRevo_Fan_Duct_40_stl();
                    else
                        E3DRevo_Fan_Duct_stl();
                Fan_Duct_hardware(blower_type);
        }
    }
    xCarriageE3DRevoStrainReliefCableTiePositions(xCarriageType)
        translate([1, railCarriageGap() + 5.4, 0])
            rotate([0, 90, -90])
                if (!exploded())
                    cable_tie(cable_r = 3.5, thickness = 5.0);

    xCarriageE3DRevoMGN9CSideZipTiePositions(size, hotendOffset, sideZipTieCutoutSize.y)
        rotate(90)
            if (!exploded())
                cable_tie(cable_r = 2.5, thickness = 2.5);
}

module xCarriageE3DRevoBack(xCarriageType, hotendDescriptor, size, extraX, fillet) {
    /*holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    extraX = 0;
    xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
    */

    sizeX = [size.x + extraX, size.y, size.z];
    carriageSize = carriage_size(xCarriageType);
    topThickness = xCarriageTopThickness();
    baseThickness = xCarriageBaseThickness();
    hotendOffset = printheadHotendOffset(hotendDescriptor);

    translate([-size.x/2, carriageSize.y/2, baseThickness]) {
        translate_z(-size.z) {
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
        }
        // extra extensions for top bolts
        translate_z(-topThickness)
            rounded_cube_yz([size.x, size.y + 2, topThickness], fillet);
        xCarriageE3DRevoStrainRelief(carriageSize, size, fillet);
    }
}

module xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX) {
    for (z = [10, 20])
        translate([strainReliefSizeX/2, 0, z])
            children();
}

module xCarriageE3DRevoStrainReliefCableTiePositions(xCarriageType, strainReliefSizeX=15) {
    xCarriageBackSizeX = xCarriageHotendSideE3DRevoSize(xCarriageType, beltWidth()).x;
    carriageSize = carriage_size(xCarriageType);

    translate([-xCarriageBackSizeX/2 - 1, carriageSize.y/2, xCarriageBaseThickness()])
        xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX)
            children();
}

module xCarriageE3DRevoStrainRelief(carriageSize, xCarriageBackSize, fillet) {
    strainReliefSizeX =  15;
    tabSize = [strainReliefSizeX, xCarriageBackSize.y, 27.5 + 2*fillet]; // ensure room for bolt heads

    difference() {
        translate_z(-2*fillet)
            rounded_cube_yz(tabSize, fillet);
        cutoutSize = [2.2, tabSize.y + 2*eps, 4.5];
        xCarriageE3DRevoStrainReliefCableTieOffsets(strainReliefSizeX)
            for (x = [-4, 4])
                translate([x - cutoutSize.x/2, -eps, -cutoutSize.z/2])
                    rounded_cube_yz(cutoutSize, 0.5);
    }
}

module E3DRevo_Fan_Duct_stl() {
    stl("E3DRevo_Fan_Duct")
        color(pp2_colour)
            fanDuct(BL30x10, 16);
}

module E3DRevo_Fan_Duct_40_stl() {
    stl("E3DRevo_Fan_Duct_40")
        color(pp2_colour)
            fanDuct(BL40x10, 16);
}

module X_Carriage_E3DRevo_MGN9C_stl() {
    stl("X_Carriage_E3DRevo_MGN9C")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevoMGN9C("E3DRevo", inserts=false);
}

module X_Carriage_E3DRevo_MGN9C_hardware() {
    xCarriageE3DRevoMGN9C_hardware("E3DRevo");
}

module X_Carriage_E3DRevo_Compact_MGN9C_stl() {
    stl("X_Carriage_E3DRevo_Compact_MGN9C")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevoMGN9C("E3DRevoCompact", inserts=false);
}

module X_Carriage_E3DRevo_Compact_MGN9C_hardware() {
    xCarriageE3DRevoMGN9C_hardware("E3DRevoCompact");
}

module X_Carriage_E3DRevo_40_MGN9C_stl() {
    stl("X_Carriage_E3DRevo_MGN9C")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageE3DRevoMGN9C("E3DRevo40", inserts=false);
}
module X_Carriage_E3DRevo_40_MGN9C_hardware() {
    xCarriageE3DRevoMGN9C_hardware("E3DRevo40");
}

