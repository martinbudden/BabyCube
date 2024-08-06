include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/sk_brackets.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/cutouts.scad>
include <../utils/diagonal.scad>
include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

include <../vitamins/cables.scad>

include <Z_MotorMount.scad>

include <../config/Parameters_Main.scad>


// in XZ plane, coordinates are [x, z, y]


SK_type = _zRodDiameter == 8 ? SK8 : _zRodDiameter == 10 ? SK10 : SK12;

innerFillet = 5;
reinforcementThickness = 5;
upperChordSize = [eSizeY, 50, eX + 2*eSizeX - 70]; // y was 25
zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;

module backFaceLeftBracketHolePositions(z=0, reversedBelts=false) {
    for (x = [backFaceBracketLowerOffset().x])
        translate([x, backFaceBracketLowerOffset().y, z])
            children();
    if (!reversedBelts)
        for (x = [backFaceBracketUpperOffset().x])
            translate([x, eZ - backFaceBracketUpperOffset().y, z])
                children();
}

module backFaceRightBracketHolePositions(z=0, reversedBelts=false) {
    for (x = [eX + 2*eSizeX - backFaceBracketLowerOffset().x])
        translate([x, backFaceBracketLowerOffset().y, z])
            children();
    if (!reversedBelts)
        for (x = [eX + 2*eSizeX - backFaceBracketUpperOffset().x])
            translate([x, eZ - backFaceBracketUpperOffset().y, z])
                children();
}

module backFaceBracketHolePositions(z=0, reversedBelts=false) {
    backFaceLeftBracketHolePositions(z=z, reversedBelts=reversedBelts)
        children();
    backFaceRightBracketHolePositions(z=z, reversedBelts=reversedBelts)
        children();
}

wiringRectWidth = 20;

function backFaceZipTiePositions(printheadWiringPosX=printheadWiringPosX()) = [
    [printheadWiringPosX + 15, 45],
    [printheadWiringPosX + 15, 80],
    [printheadWiringPosX, 110],
    [printheadWiringPosX, eZ - 40]
];

module backFaceZipTiePositions() {
    for (pos = backFaceZipTiePositions(printheadWiringPosX()))
        translate([pos.x, pos.y])
            children();
}

module backFaceCableTies() {
    translate([0, eY + eSizeY, 0])
        rotate([90, 0, 0])
            backFaceZipTiePositions()
                translate_z(-2*printheadWireRadius() - _backPlateThickness + 1)
                    rotate(90)
                        cable_tie(cable_r=printheadWireRadius() + 0.5, thickness=_backPlateThickness);
}

module backFaceBare(NEMA_type, fullyEnclosed=false) {
    assert(isNEMAType(NEMA_type));

    cutoutSize = [2, 4, eZ + 2*eps];
    zipTieCutoutSize = [10, 4, (_backPlateThickness + eps)*2];
    zipTieBridgeSize = [ 6, 15, 2];
    backLowerChordSizeY = 20 + _zRodOffsetZ;

    // side chords
    for (x = [eSizeXBase, eX - 2])
        translate([x, backLowerChordSizeY, 0])
            rounded_cube_xy([eSizeX, middleWebOffsetZ() - backLowerChordSizeY, reinforcementThickness], _fillet);

    // thin webbing
    translate_z(-_backPlateThickness) {
        // left side
        horizontalRectSize = [20, eZ - 2*eSizeZ, _backPlateThickness];
        rounded_cube_xy(horizontalRectSize, r=1);
        translate([horizontalRectSize.x, eZ - upperChordSize.y, 0])
            rotate(-90)
                fillet(innerFillet, _backPlateThickness);
        // right side with webbing for wiring
        wiringRectPosX = printheadWiringPos().x - wiringRectWidth/2;
        translate([wiringRectPosX, Z_MotorMountHeight(NEMA_type), 0])
            rotate(90)
                fillet(innerFillet, _backPlateThickness);
        difference() {
            union() {
                translate([wiringRectPosX, 2*eSizeZ, 0])
                    cube([eX + 2*eSizeX - wiringRectPosX, eZ - 4*eSizeZ, _backPlateThickness]);
                // diagonal brace
                diagonalFromTo(
                    [horizontalRectSize.x, Z_MotorMountHeight(NEMA_type), 0],
                    [wiringRectPosX, eZ - upperChordSize.y, 0],
                    _backPlateThickness,
                    1.5*min(eSizeX, eSizeZ),
                    innerFillet/2);
                if (fullyEnclosed)
                    translate([horizontalRectSize.x - 1, Z_MotorMountHeight(NEMA_type) -1, 0])
                        cube([wiringRectPosX - horizontalRectSize.x + 2, eZ - upperChordSize.y -Z_MotorMountHeight(NEMA_type) + 2, 1]);
                //echo(printheadWiringPosX=printheadWiringPosX());
                //echo(diag=[wiringRectPosX-horizontalRectSize.x, eZ - upperChordSize.y-Z_MotorMountHeight(NEMA_type)]);
            }
            // cutouts for zipties
            backFaceZipTiePositions()
                rounded_cube_xy(zipTieCutoutSize, r=1, xy_center=true, z_center=true);
        }
    }

    backFaceZipTiePositions()
        translate_z(-zipTieBridgeSize.z)
            rounded_cube_xy(zipTieBridgeSize, r=0.5, xy_center=true, z_center=false);
}

module backFaceUpperSKBracketHolePositions(yOffset) {
    translate([zRodOffsetX, eZ - sk_size(SK_type).z/2 - yOffset, 0])
        for (x = [0, _zRodSeparation], s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
            translate([x + s, 0, 0])
                children();
}

module backFaceUpperBrackets(NEMA_width, yOffset) {
    upperChordSizeY = 25;
    fcHeight = eSizeY + (eX + 2*eSizeX - upperChordSize.z)/2;
    rectSize = [eX + 2*eSizeX - 2*fcHeight, upperChordSizeY - _topPlateThickness-sk_size(SK_type).z - 1, reinforcementThickness];

    translate([fcHeight, eZ - upperChordSizeY, 0])
        rounded_cube_xy(rectSize, 1);

    difference() {
        union() {
            boltRectSize = [50, upperChordSizeY - _topPlateThickness, 8];
            translate([(eX + 2*eSizeX - boltRectSize.x)/2, eZ - boltRectSize.y - _topPlateThickness, 0])
                rounded_cube_xy(boltRectSize, 1);
            translate([0, eZ - upperChordSize.y, -_backPlateThickness])
                rounded_cube_xy([eX + 2*eSizeX, upperChordSize.y, _backPlateThickness], r=1);
        }
        backFaceUpperSKBracketHolePositions(yOffset)
            translate_z(-_backPlateThickness)
                boltPolyholeM5Countersunk(_backPlateThickness, sink=0.25);

        rotate([-90, 0, 0]) 
            translate([0, -eY - 2*eSizeY - eps, eZ - _topPlateThickness]) 
                topFaceBackHolePositions()
                    vflip()
                        boltHoleM3Tap(8, horizontal=true, chamfer_both_ends=false);
        /*topFaceBackHolePositions(topFaceBackHolePositionOffsetY())
            rotate([90, 0, 0])
                translate_z(13 - topFaceBackHolePositionOffsetY())
                    boltHoleM3Tap(8, horizontal=true, chamfer_both_ends=false);*/

        // always make cutout for yRail, so back face can be used if _fullLengthYRail is true or not
        //if (_fullLengthYRail)
        railsCutout(NEMA_width, yRailOffset(NEMA_width));
    }

    /*translate([zRodOffsetX, _zRodLength - rodBracketSize().y + eSizeY/2, 0]) {
        rodBracket(rodDiameter=_zRodDiameter, rodOffset=_zRodOffsetY);
        translate([_zRodSeparation, 0, 0])
            rotate(180) // so bolts don't block z carriage
                rodBracket(rodDiameter=_zRodDiameter, rodOffset=_zRodOffsetY);
    }*/
}

module backFaceUpperBracketsHardware(backPlateThickness, yOffset, counterSunk=true) {
    translate([zRodOffsetX, eZ - sk_size(SK_type).z/2 - yOffset, 0])
        explode(20, true)
            for (x = [0, _zRodSeparation]) {
                translate([x, 0, _zRodOffsetY])
                    rotate([90, 0, x==0 ? 0 : 180])
                        sk_bracket(SK_type);
                for (s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
                    translate([x + s, 0, -backPlateThickness]) {
                        vflip()
                            explode(30, true)
                                if (counterSunk)
                                    boltM5Countersunk(16);
                                else
                                    boltM5Buttonhead(16);
                        translate_z(backPlateThickness + sk_base_height(SK_type))
                            nut(M5_nut, nyloc=true);
                    }
            }
}

module backFaceLowerSKBracketHolePositions(yOffset) {
    translate([zRodOffsetX, sk_size(SK_type).z/2 + yOffset, 0])
        for (x = [0, _zRodSeparation], s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
            translate([x + s, 0, 0])
                children();
}

module backFaceLowerBrackets(NEMA_type, yOffset) {
    assert(isNEMAType(NEMA_type));

    translate_z(-_backPlateThickness)
        difference() {
            rounded_cube_xy([eX + 2*eSizeX, Z_MotorMountHeight(NEMA_type), _backPlateThickness], r=1);
            backFaceLowerSKBracketHolePositions(yOffset)
                boltPolyholeM5Countersunk(_backPlateThickness, sink=0.25);
        }
    translate([zRodOffsetX + _zRodSeparation/2, 0, _zLeadScrewOffset])
        rotate([-90, -90, 0])
            Z_MotorMount(NEMA_type);

    backLowerChordSizeY = 20 + _zRodOffsetZ;
    fillet = 1;
    rectSize = [(eX - Z_MotorMountSize(NEMA_type).y + 7)/2, 10, reinforcementThickness];
    for (x = [eSizeXBase, eX + eSizeX - rectSize.x])
        translate([x, backLowerChordSizeY, 0])
            rounded_cube_xy(rectSize - [2, 0, 0], fillet);
    translate([eSizeXBase + eSizeX, rectSize.y + backLowerChordSizeY, 0])
        fillet(innerFillet, reinforcementThickness);
    translate([eX - 2, rectSize.y + backLowerChordSizeY, 0])
        rotate(90)
            fillet(innerFillet, reinforcementThickness);
    translate([eSizeX + rectSize.x - 3, backLowerChordSizeY, 0])
        rotate(180)
            fillet(5, rectSize.z);
    translate([eX + eSizeX - rectSize.x + 3, backLowerChordSizeY, 0])
        rotate(-90)
            fillet(5, rectSize.z);
}

module backFaceLowerBracketsHardware(backPlateThickness, yOffset, counterSunk=true) {
    translate([zRodOffsetX, sk_size(SK_type).z/2 + yOffset, 0])
        explode(20, true)
            for (x = [0, _zRodSeparation]) {
                translate([x, 0, _zRodOffsetY])
                    rotate([90, 0, x==0 ? 180 : 0])
                        sk_bracket(SK_type);
                for (s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
                    translate([x + s, 0, -backPlateThickness]) {
                        vflip()
                            explode(30, true)
                                if (counterSunk)
                                    boltM5Countersunk(16);
                                else
                                    boltM5Buttonhead(16);
                        translate_z(backPlateThickness + sk_base_height(SK_type))
                            nut(M5_nut, nyloc=true);
                    }
            }
}

module backFaceMotorMountHardware(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    stepper_motor_cable(150);
    translate([zRodOffsetX + _zRodSeparation/2, 0, _zLeadScrewOffset])
        rotate([-90, -90, 0])
            Z_MotorMountHardware(NEMA_type);
}
