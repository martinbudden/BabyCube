include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/pcbs.scad>

include <../utils/HolePositions.scad>

include <../vitamins/bolts.scad>

use <Base.scad> // for pcb position
use <DisplayHousing.scad>
use <XY_IdlerBracket.scad>

include <../Parameters_Main.scad>


fillet = _fillet;

module Front_Upper_Chord_stl() {
    size = frontUpperChordSize();
    cutoutHeight = size.z - faceConnectorOverlapHeight();
    overlap = faceConnectorOverlap();

    stl("Front_Upper_Chord")
        color(pp2_colour)
            translate([-eX - 2*eSizeX, -size.y, 0])
                difference() {
                    translate([(eX + 2*eSizeX - size.x)/2, 0, 0])
                        union() {
                            rounded_cube_xy(size - [0, 0, cutoutHeight], fillet);
                            offsetY = 6;
                            translate([overlap, offsetY, size.z - cutoutHeight])
                                rounded_cube_xy([size.x - 2*overlap, size.y - offsetY - _topPlateThickness, cutoutHeight], 1);
                        }
                    for (x = [overlap/2, size.x - overlap/2], y = idlerBracketTopSizeY()/2)
                        translate([x + (eX + 2*eSizeX - size.x)/2, y, 0])
                            boltPolyholeM3Countersunk(cutoutHeight, sink=0.25);
                    translate([0, size.y, 0])
                        rotate([90, 0, 0])
                            topFaceFrontHolePositions(_topPlateThickness)
                                boltHoleM3Tap(8, horizontal = true, chamfer_both_ends = false);
                    translate([eX + 2*eSizeX, size.y, 0 - eps])
                        frontUpperChordMessage(size, _cubeName);
                }
}

module Front_Upper_Chord_hardware() {
    size = frontUpperChordSize();
    overlap = faceConnectorOverlap();

    translate([-eX - 2*eSizeX, -size.y, 0])
        for (x = [overlap/2, size.x - overlap/2], y = [size.y-15])
            translate([x + (eX + 2*eSizeX - size.x)/2, y, 2*eps])
                vflip()
                    boltM3Countersunk(10);
}

module frontUpperChordMessage(size=frontUpperChordSize(), message=_cubeName, messageDepth = 2) {
    translate([-(eX + 2*eSizeX)/2, -size.y/2, 0 - eps])
        linear_extrude(messageDepth)
            mirror([1, 0, 0])
                text(message, size=14, font="Calibri", halign="center", valign="center");
}


module frontLowerChord() {
    size = frontLowerChordSize();
    cutoutHeight = size.z - faceConnectorOverlapHeight();
    overlap = faceConnectorOverlap();

    difference() {
        translate([(eX + 2*eSizeX - size.x)/2, 0, 0])
            union() {
                rounded_cube_xy(size - [0, 0, cutoutHeight], fillet);
                translate([overlap, 0, size.z - cutoutHeight])
                    rounded_cube_xy([size.x - 2*overlap, size.y, cutoutHeight], 1);
            }
        mirror([0, 0, 1])
            rotate([-90, 0, 0])
                baseFrontHolePositions()
                    boltHoleM3Tap(8, horizontal = true, rotate = -90, chamfer_both_ends = false);
        for (x = [overlap/2, size.x - overlap/2], y = [5, size.y/2, size.y - 5])
            translate([x + (eX + 2*eSizeX - size.x)/2, y, 0])
                boltPolyholeM3Countersunk(cutoutHeight, sink=0.25);
    }
}

module frontLowerChordHardware() {
    size = frontLowerChordSize();
    cutoutHeight = size.z - faceConnectorOverlapHeight();
    overlap = faceConnectorOverlap();

    rotate([90, 0, 180])
        translate([-eX - 2*eSizeX, 0, 0])
            for (x = [overlap/2, size.x - overlap/2], y = [5, size.y/2, size.y - 5])
                translate([x + (eX + 2*eSizeX - size.x)/2, y, 2*eps])
                    vflip()
                        boltM3Countersunk(10);
}

module Front_Lower_Chord_Solid_stl() {
    stl("Front_Lower_Chord")
        translate([-eX - 2*eSizeX, 0, 0])
            color(pp2_colour)
                frontLowerChord();
}

module Front_Lower_Chord_stl() {
    display_type = BigTreeTech_TFT35v3_0;// BTT_TFT35_V3_0;

    stl("Front_Lower_Chord")
        translate([-eX - 2*eSizeX, 0, 2*eps])
            color(pp2_colour)
                frontLowerChordSKR_1_4(headless = false);
}

module Front_Lower_Chord_hardware() {
    display_type = BigTreeTech_TFT35v3_0;// BTT_TFT35_V3_0;

    translate([-eX/2 - eSizeX, -1, 5])
        rotate([90, 0, 180])
            displayBracketHolePositions(display_type)
                vflip()
                    boltM3Buttonhead(16);
}

module Front_Lower_Chord_SKR_1_4_Headless_stl() {
    stl("Front_Lower_Chord_SKR_1_4_Headless")
        translate([-eX - 2*eSizeX, 0, 0])
            color(pp2_colour)
                frontLowerChordSKR_1_4(headless = true);
}

function frontChordCutoutSize(display_type=BigTreeTech_TFT35v3_0, cnc=false)  = [displayHousingInnerWidth(display_type) + 6, (cnc ? 24 : 26), frontLowerChordSize().z + 2*eps];
//function lowerChordHeight() = idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z;
//function frontChordCutoutOffset(display_type=BigTreeTech_TFT35v3_0, headless=false) = [-lowerChordHeight() - (frontChordCutoutSize(display_type).x + frontLowerChordSize().z)/2, 8, -eps + (headless ? 1 : 0)];


module frontLowerChordSKR_1_4_cutout(display_type, cnc=false) {
    cutoutSize = frontChordCutoutSize(display_type, cnc);

    if (cnc)
        translate([(eX + 2*eSizeX - cutoutSize.x)/2, 10])
            rounded_square([cutoutSize.x, cutoutSize.y], 2, center=false);
    else
        translate([(eX + 2*eSizeX - cutoutSize.x)/2, 8, -eps])
            rounded_cube_xy(cutoutSize + [0, 0, 2*eps], 2);
}

module frontLowerChordSKR_1_4(headless=false) {
    display_type = BigTreeTech_TFT35v3_0;// BTT_TFT35_V3_0;
    pcb_type = BTT_SKR_V1_4_TURBO;
    pcbSize = pcb_size(pcb_type);

//    cutoutSize  = [displayHousingInnerWidth(display_type), 26, frontLowerChordSize().x + 2*eps];
//    cutoutOffset = [-lowerChordHeight() - (cutoutSize.x + frontLowerChordSize().z)/2, 8, -eps + (headless ? 1 : 0)];
    cutoutSize = frontChordCutoutSize(display_type);
    cutoutOffset = [cutoutSize.x/2, 8, 0];//frontChordCutoutOffset(headless);
    standoffHeight = pcbOffsetFromBase() - cutoutOffset.y;
    translate([0, standoffHeight+cutoutOffset.y, 0])
        rotate([90, 0, 0])
            pcbPosition(pcb_type)
                pcb_front_screw_positions(pcb_type)
                    difference() {
                        hull() {
                            cubeSize = [5, 5, standoffHeight];
                            translate([-cubeSize.x/2, -2.5 - cubeSize.y/2, 0])
                                cube(cubeSize);
                            cylinder(d=5, h=standoffHeight);
                        }
                        boltHoleM3Tap(standoffHeight, horizontal=true);
                    }

    difference() {
        frontLowerChord();
        if (headless) {
            // cutout for USB
            usbPos = pcb_component_position(pcb_type, "usb_B");
            usbCutoutSize = [14, 12, 2];
            translate([-eX/2 - eSizeX - usbPos.x - usbCutoutSize.x/2, pcbOffsetFromBase() + 1, cutoutOffset.z-1])
                rounded_cube_xy(usbCutoutSize, 1);

            // cutout for tfCard
            tfCardPos = pcb_component_position(pcb_type, "uSD");
            tfCardCutoutSize = [16, 3, 2];
            translate([-eX/2 - eSizeX - tfCardPos.x - tfCardCutoutSize.x/2, pcbOffsetFromBase() + 1, cutoutOffset.z-1])
                rounded_cube_xy(tfCardCutoutSize, 1);

        } else {
            // bolt holes
            translate([eX/2 + eSizeX, -1, 5])
                rotate([90, 0, 180])
                    displayBracketHolePositions(display_type)
                        boltHoleM3(10);
        }

        frontLowerChordSKR_1_4_cutout(display_type);
        mirror([0, 1, 0])
            rotate([90, 0, 0])
                pcbPosition(pcb_type)
                    pcb_screw_positions(pcb_type) {
                        boltHoleM3Tap(cutoutOffset.y, horizontal = true);
                        // add an access hole for the bolts
                        translate_z(cutoutSize.y + cutoutOffset.y)
                            boltHoleM3(frontLowerChordSize().y - (cutoutSize.y + cutoutOffset.y), horizontal = true);
                    }
    }
}
