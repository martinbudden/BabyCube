include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/sk_brackets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
use <NopSCADlib/vitamins/wire.scad>

use <../utils/bezierTube.scad>
use <../utils/carriageTypes.scad>
use <../utils/cutouts.scad>
use <../utils/diagonal.scad>
use <../utils/HolePositions.scad>
use <../utils/PrintHeadOffsets.scad>
include <../utils/motorTypes.scad>

use <../vitamins/bolts.scad>
use <../vitamins/cables.scad>

use <X_Carriage.scad>
use <Z_MotorMount.scad>

use <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


// in XZ plane, coordinates are [x, z, y]


SK_type = _zRodDiameter == 8 ? SK8 : _zRodDiameter == 10 ? SK10 : SK12;

innerFillet = 5;
reinforcementThickness = 5;
//upperChordSize = [backUpperChordSize().x, backUpperChordSize().y+3, backUpperChordSize().z];
//upperChordSize = [backUpperChordSize().x, sk_size(SK_type).z + _topPlateThickness + 8, backUpperChordSize().z-2];
upperChordSize = [eSizeY, sk_size(SK_type).z + _topPlateThickness + 8, eX + 2*eSizeX - 54];
zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;

module backFaceBracketHolePositions(z=0) {
    for (x = [backFaceBracketLowerOffset().x, eX + 2*eSizeX - backFaceBracketLowerOffset().x])
        translate([x, backFaceBracketLowerOffset().y, z])
            children();
    for (x = [backFaceBracketUpperOffset().x, eX + 2*eSizeX - backFaceBracketUpperOffset().x])
        translate([x, eZ - backFaceBracketUpperOffset().y, z])
            children();
}

wiringRectWidth = 20;
zipTiePositions = [
    [printheadWiringPos().x + 15, 45],
    [printheadWiringPos().x + 15, 80],
    [printheadWiringPos().x, 110],
    [printheadWiringPos().x, eZ - 40]
];

module zipTiePositions() {
    for (pos = zipTiePositions)
        translate([pos.x, pos.y])
            children();
}

module backFaceCableTies() {
    translate([0, eY + eSizeY, 0])
        rotate([90, 0, 0])
            zipTiePositions()
                translate_z(-2*printheadWireRadius() - _backPlateThickness + 1)
                    rotate(90)
                        cable_tie(cable_r=printheadWireRadius() + 0.5, thickness=_backPlateThickness);
}

module printheadWiring() {
    vitamin(str(": Spiral wrap, 500mm"));

    endPos = [carriagePosition().x + eSizeX - 6 - xCarriageFrontSize(xCarriageType()).x/2, carriagePosition().y + xCarriageBackOffsetY(xCarriageType()), eZ] + printheadWiringOffset();
    zp = zipTiePositions;
    y = eY + 2*eSizeY - printheadWireRadius();
    p = [
        [ zp[0].x, y, zp[0].y ],
        [ zp[1].x, y, zp[1].y -5 ],
        [ zp[1].x, y, zp[1].y ],
        [ zp[1].x, y, zp[1].y + 5 ],
        [ zp[1].x, y, zp[1].y + 10 ],
        [ zp[1].x, y, zp[1].y + 15 ],
        [ zp[2].x, y, zp[2].y - 15],
        [ zp[2].x, y, zp[2].y - 12],
        [ zp[2].x, y, zp[2].y - 11],
        [ zp[2].x, y, zp[2].y - 10],
        [ zp[2].x, y, zp[2].y - 5],
        [ zp[2].x, y, zp[2].y ],
        [ zp[2].x, y, zp[2].y + 5],
        [ zp[3].x, y, zp[3].y - 5 ],
        [ zp[3].x, y, zp[3].y - 10 ],
        [ zp[3].x, y, zp[3].y - 11 ],
        [ zp[3].x, y, zp[3].y],
        [ zp[3].x, y, zp[3].y + 5],
        [ zp[3].x, y, zp[3].y + 6],
        [ zp[3].x, y, zp[3].y + 10],
        [ zp[3].x, y - 15, eZ - 10],
        [ zp[3].x, printheadWiringPos().y, eZ - 7],
        [ zp[3].x, printheadWiringPos().y, eZ - 6],
        [ zp[3].x, printheadWiringPos().y, eZ - 5],
        [ zp[3].x, printheadWiringPos().y, eZ],
        printheadWiringPos(),
        printheadWiringPos() + [0, -5, 5],
        printheadWiringPos() + [0, -5, 50],
        printheadWiringPos() + [0, -5, 100],
        (printheadWiringPos() + endPos)/2 + [0, 0, 180],
        endPos + [0, 0, 100],
        endPos + [0, 0, 50],
        endPos,
    ];
    bezierTube2(p, color=grey(20), tubeRadius=printheadWireRadius());

}



module backFaceBare(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    cutoutSize = [2, 4, eZ + 2*eps];
    zipTieCutoutSize = [10, 4, (_backPlateThickness + eps)*2];
    zipTieBridgeSize = [ 6, 15, 2];
    backLowerChordSizeY = 20;

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
                //echo(printheadWiringPosX=printheadWiringPosX());
                //echo(diag=[wiringRectPosX-horizontalRectSize.x, eZ - upperChordSize.y-Z_MotorMountHeight(NEMA_type)]);
            }
            // cutouts for zipties
            zipTiePositions()
                rounded_cube_xy(zipTieCutoutSize, r=0.5, xy_center=true, z_center=true);
        }
    }

    zipTiePositions()
        translate_z(-zipTieBridgeSize.z)
            rounded_cube_xy(zipTieBridgeSize, r=0.5, xy_center=true, z_center=false);
}

module backFaceUpperSKBracketHolePositions() {
    translate([zRodOffsetX, _zRodLength - sk_size(SK_type).z/2 - _topPlateThickness, 0])
        for (x = [0, _zRodSeparation], s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
            translate([x + s, 0, 0])
                children();
}

module backFaceUpperBrackets(NEMA_width) {

    fcHeight = eSizeY + (eX + 2*eSizeX - upperChordSize.z)/2;
    rectSize = [eX + 2*eSizeX - 2*fcHeight, upperChordSize.y-_topPlateThickness-sk_size(SK_type).z-1, reinforcementThickness];

    translate([fcHeight, eY + 2*eSizeY - upperChordSize.y, 0])
        rounded_cube_xy(rectSize, 1);

    difference() {
        union() {
            boltRectSize = [56, upperChordSize.y - _topPlateThickness, 8];
            translate([(eX + 2*eSizeX - boltRectSize.x)/2, eZ - boltRectSize.y - _topPlateThickness, 0])
                rounded_cube_xy(boltRectSize, 1);
            translate([0, eZ - upperChordSize.y, -_backPlateThickness])
                rounded_cube_xy([eX + 2*eSizeX, upperChordSize.y, _backPlateThickness], r=1);
        }
        backFaceUpperSKBracketHolePositions()
            translate_z(-_backPlateThickness)
                boltPolyholeM5Countersunk(_backPlateThickness, sink=0.25);
        backFaceTopHolePositions()
            rotate([90, 0, 0])
                boltHoleM3Tap(8+10, horizontal = true, chamfer_both_ends = false);

        railsCutout(NEMA_width, yRailOffset(NEMA_width));
    }

    /*translate([zRodOffsetX, _zRodLength - rodBracketSize().y + eSizeY/2, 0]) {
        rodBracket(rodDiameter=_zRodDiameter, rodOffset=_zRodOffsetY);
        translate([_zRodSeparation, 0, 0])
            rotate(180) // so bolts don't block z carriage
                rodBracket(rodDiameter=_zRodDiameter, rodOffset=_zRodOffsetY);
    }*/
}

module backFaceUpperBracketsHardware(backPlateThickness, counterSunk = true) {
    explode(20, true)
        translate([zRodOffsetX, _zRodLength - sk_size(SK_type).z/2 - _topPlateThickness, 0])
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
                            nut(M5_nut, nyloc = true);
                    }
            }
}

module backFaceLowerSKBracketHolePositions() {
    translate([zRodOffsetX, sk_size(SK_type).z/2, 0])
        for (x = [0, _zRodSeparation], s = [-sk_screw_separation(SK_type)/2, sk_screw_separation(SK_type)/2])
            translate([x + s, 0, 0])
                children();
}

module backFaceLowerBrackets(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    translate_z(-_backPlateThickness)
        difference() {
            rounded_cube_xy([eX+2*eSizeX, Z_MotorMountHeight(NEMA_type), _backPlateThickness], r=1);
            backFaceLowerSKBracketHolePositions()
                boltPolyholeM5Countersunk(_backPlateThickness, sink=0.25);
        }
    translate([zRodOffsetX + _zRodSeparation/2, 0, _zLeadScrewOffset])
        rotate([-90, -90, 0])
            Z_MotorMount(NEMA_type);

    backLowerChordSizeY = 20;
    fillet = 1;
    rectSize = [(eX - Z_MotorMountSize(NEMA_type).y + 5)/2, 10, reinforcementThickness];
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

module backFaceLowerBracketsHardware(backPlateThickness, counterSunk=true) {
    explode(20, true)
        translate([zRodOffsetX, sk_size(SK_type).z/2, 0])
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
                            nut(M5_nut, nyloc = true);
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
