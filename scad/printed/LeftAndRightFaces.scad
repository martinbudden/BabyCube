include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/rockers.scad>
use <NopSCADlib/vitamins/wire.scad>

use <../utils/carriageTypes.scad>
use <../utils/cutouts.scad>
use <../utils/diagonal.scad>
use <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

use <../vitamins/bolts.scad>
use <../vitamins/inserts.scad>

use <SwitchShroud.scad>
use <XY_MotorMount.scad>
use <XY_IdlerBracket.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function extruderMotorType() = NEMA17M;

backBoltLength = 8;


fillet = _fillet;
innerFillet = 5;
upperWebThickness = 3;
antiShearSize = [eY + 2*eSizeY, 20];
switchShroudSizeX = 60;//switchShroudSize().x;
upperFillet = 1.5;


function rocker_type() = small_rocker;
function rockerPosition(rocker_type) = [0, rocker_height(rocker_type)/2 + frontLowerChordSize().y + 3, eSizeX + eps + rocker_slot_w(rocker_type)/2];
function extruderMotorOffsetZ() = upperWebThickness;
function extruderPosition(NEMA_width) = [eX + 2*eSizeX, eY - 2*NEMA_width + 2*35.2 - 40 - motorClearance().y, eZ - 73];
function spoolHolderPosition() = [eX + 2*eSizeX, 24, eZ - 75];
function frontReinforcementThickness() = 3;
function spoolHolderBracketSize() = [eSizeX, 30, 20];


module leftFace(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    difference() {
        union() {
            frame(NEMA_type, left=true);
            webbingLeft(NEMA_type);
            NEMA_width = NEMA_width(NEMA_type);
            translate([0, coreXYPosBL(NEMA_width, yCarriageType()).z + coreXYSeparation().z])
                XY_IdlerBracket(coreXYPosBL(NEMA_width), NEMA_width, 0);
            XY_MotorUpright(NEMA_type, left=true);
        }
        switchShroudHolePositions()
            boltPolyholeM3Countersunk(eSizeXBase, sink=0.25);
        translate(rockerPosition(rocker_type()))
            rotate([0, -90, 0])
                rocker_hole(rocker_type(), eSizeY, rounded = false);
        /*translate([0, eZ - _topPlateThickness, eX + 2*eSizeX])
            rotate([90, 90, 0])
                topFaceSideHolePositions()
                    boltHoleM3Tap(topBoltHolderSize().y, horizontal = true, rotate = 90);*/
    }
}

module rightFace(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    // orient the right face for printing
    rotate(180)
        mirror([0, 1, 0])
            difference() {
                union() {
                    frame(NEMA_type, left=false);
                    webbingRight(NEMA_type);
                    NEMA_width = NEMA_width(NEMA_type);
                    translate([0, coreXYPosBL(NEMA_width, yCarriageType()).z + coreXYSeparation().z, 0])
                        XY_IdlerBracket(coreXYPosBL(NEMA_width, yCarriageType()), NEMA_width);
                    XY_MotorUpright(NEMA_type, left=false);
                }
                /*translate([0, eZ - _topPlateThickness, eX + 2*eSizeX])
                    rotate([90, 90, 0])
                        topFaceSideHolePositions()
                            //boltHoleM3Tap(topBoltHolderSize().y, horizontal = true, rotate = 90);
                            translate_z(-eps)
                                rotate(30)
                                    poly_cylinder(r=M3_tap_radius, h=topBoltHolderSize().y-2, sides=6);*/
            }
}

module sideFaceMotorCutout(left, NEMA_width, cnc=false) {
    cutoutHeight = NEMA_width < 40 ? 40 : 50;
    translate([coreXYPosTR(NEMA_width).y, xyMotorPositionYBase(NEMA_width, left) - coreXYSeparation().z/2 - _xyMotorBracketThickness, 0])
        motorCutout([NEMA_width + 3, cutoutHeight, cnc ? 0 : _webThickness], upperFillet);
}

module motorCutout(size, upperFillet) {
    lowerFillet = 3;
    if (size.z == 0)
        translate([-size.x/2, -size.y + 0.75]) {
            translate([0, lowerFillet*2])
                rounded_square([size.x, size.y - lowerFillet*2], upperFillet, center=false);
            rounded_square([size.x, size.y - lowerFillet*2 - 1], lowerFillet, center=false);
        }
    else
        // !!TODO fix this magic number 0.75
        translate([-size.x/2, -size.y + 0.75, -2*eps]) {
            translate([0, lowerFillet*2])
                rounded_cube_xy([size.x, size.y - lowerFillet*2, size.z + 4*eps], upperFillet);
            rounded_cube_xy([size.x, size.y - lowerFillet*2 - 1, size.z + 4*eps], lowerFillet);
        }
}


module antiShearBracing(NEMA_width) {
    // add some anti-shear bracing at the top of the frame
    difference() {
        translate([0, eZ - antiShearSize.y])
            rounded_square(antiShearSize, fillet, center=false);
        sideFaceTopDogbones();
    }
}

module webbingLeft(NEMA_type) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);
    left = true;
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width));

    // not needed as covered by diagonal
    *translate([idlerBracketSize.x, eZ - antiShearSize.y, 0])
        rotate(-90)
            fillet(innerFillet, upperWebThickness);

    // shroud for switch
    translate([fillet, 0, 0])
        cube([switchShroudSizeX - fillet, middleWebOffsetZ(), _webThickness]);
    *translate([switchShroudSizeX, eSizeZ, 0]) // not needed, since covered by diagonal
        fillet(innerFillet, _webThickness);
    translate([switchShroudSizeX, middleWebOffsetZ(), 0])
        rotate(-90)
            fillet(innerFillet, _webThickness);
    // upright by motor
    uprightPos = [coreXYPosTR(NEMA_width).y - 2 - NEMA_width/2 - eSizeY, middleWebOffsetZ(), 0];
    linear_extrude(upperWebThickness)
        difference() {
            union() {
                translate(uprightPos)
                    square([eY + 2*eSizeY - uprightPos.x, eZ - yRailSupportThickness() - middleWebOffsetZ() -cnc_bit_r]);
                antiShearBracing(NEMA_width);
                translate([uprightPos.x, eZ - antiShearSize.y])
                    rotate(180)
                        fillet(innerFillet);
                // idler upright
                rounded_square([eSizeY, eZ - eSizeZ + fillet], 3, center=false);
                translate([0, middleWebOffsetZ(), 0])
                    rounded_square([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness], fillet, center=false);
                if (_sideTabs)
                    sideFaceBackTabs();
            }
            sideFaceMotorCutout(left, NEMA_width, cnc=true);
        }
    // diagonal brace by motor
    translate([idlerBracketSize.x, middleWebOffsetZ() + eSizeZ, 0])
        //diagonalDown([uprightPos.x - idlerBracketSize.x, middleWebOffsetZ() - 35 - eSizeZ, _webThickness], min(eSizeY, eSizeZ), 5, extend=true);
        diagonalDown([uprightPos.x - idlerBracketSize.x, eZ - eSizeZ - middleWebOffsetZ()-antiShearSize.y, upperWebThickness], min(eSizeY, eSizeZ), 5);
    // main diagonal brace
    translate([switchShroudSizeX, eSizeZ, 0])
        diagonal([eY + eSizeY - switchShroudSizeX, middleWebOffsetZ() - eSizeZ, _webThickness], min(eSizeY, eSizeZ), 5);
}

module spoolHolderCutout(NEMA_width, cnc=false) {

    width = (extruderPosition(NEMA_width).y - XY_MotorMountSize(NEMA_width).y)/2;
    if (cnc)
        translate([eSizeY+5, spoolHolderPosition().z])
            rounded_square([50, eZ - antiShearSize.y - spoolHolderPosition().z], innerFillet, center=false);
    else
        translate([idlerBracketSize(coreXYPosBL(NEMA_width)).x, spoolHolderPosition().z])
            rounded_square([extruderPosition(NEMA_width).y - width/2 - eSizeY-idlerBracketSize(coreXYPosBL(NEMA_width)).x, eZ - antiShearSize.y - spoolHolderPosition().z], innerFillet, center=false);
}

module webbingRight(NEMA_type) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);
    left = false;
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width));

    // main diagonal brace
    translate([eSizeY + eps, eSizeZ - eps, 0]) // eps displacement probably not necessary
        diagonalDown([eY + 2*eps, middleWebOffsetZ() - eSizeZ + 2*eps, _webThickness], min(eSizeY, eSizeZ), 5);

    extruderPosition = extruderPosition(NEMA_width);
    width = (extruderPosition.y - XY_MotorMountSize(NEMA_width).y)/2;
    // plate to hold extruder
    linear_extrude(upperWebThickness)
        difference() {
            union() {
                translate([0, middleWebOffsetZ()])
                    //square([eY + eSizeY - XY_MotorMountSize(NEMA_width).y + eps, eZ - middleWebOffsetZ() - _topPlateThickness]);
                    square([eY + 2*eSizeY, eZ - middleWebOffsetZ() - _topPlateThickness - cnc_bit_r]);
                antiShearBracing(NEMA_width);
                // idler upright
                rounded_square([eSizeY, eZ - eSizeZ + fillet], 3, center=false);
                translate([0, middleWebOffsetZ(), 0])
                    rounded_square([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness], fillet, center=false);
                if (_sideTabs)
                    sideFaceBackTabs();
            }
            translate([extruderPosition.y, extruderPosition.z]) {
                poly_circle(r = NEMA_boss_radius(extruderMotorType()) + 0.25);
                // extruder motor bolt holes
                NEMA_screw_positions(extruderMotorType())
                    poly_circle(r = M3_clearance_radius);
            }
            spoolHolderCutout(NEMA_width);
            sideFaceMotorCutout(left, NEMA_width, cnc=true);
        }

    // support for the spoolholder
    offset = 22.5;
    translate([0, middleWebOffsetZ(), 0])
        rounded_cube_xy([extruderPosition.y - offset - eSizeY + innerFillet, spoolHolderPosition().z - middleWebOffsetZ(), eSizeX], innerFillet);
    translate([idlerBracketSize.x + spoolHolderBracketSize().z + 0.5, middleWebOffsetZ(), 0])
        rounded_cube_xy([10, spoolHolderPosition().z - middleWebOffsetZ(), eSizeX + 5], 2);
    translate([extruderPosition.y - offset - eSizeY + innerFillet, middleWebOffsetZ() + eSizeZ, 0])
        fillet(innerFillet, eSizeX);
    translate([idlerBracketSize.x, spoolHolderPosition().z, 0])
        fillet(innerFillet, eSizeX);

    translate([0, middleWebOffsetZ(), 0]) {
        height = eSizeZ + 5;
        rounded_cube_xy([idlerBracketSize.x, 3*eSizeZ, height], fillet);
        translate([frontReinforcementThickness(), 0, 0])
            rotate(270)
                fillet(innerFillet, height);
        translate([frontReinforcementThickness(), 3*eSizeZ, 0])
            fillet(innerFillet, height);
    }
}

motorUprightWidth = max(10, eSizeY); // make sure at least 10 wide, to accept inserts

module motorUpright(NEMA_width, left) {

    uprightTopZ = coreXYPosBL(NEMA_width, yCarriageType()).z - (left ? 0 : coreXYSeparation().z);
    uprightPosZ = middleWebOffsetZ() + eSizeZ - 2*fillet;
    upperFillet =1.5;
    translate([eY + 2*eSizeY - motorClearance().y + upperFillet, uprightPosZ, 0])
        cube([motorClearance().y - upperFillet, uprightTopZ - uprightPosZ, eSizeX]);
}

module idlerUpright(NEMA_width, left) {
    difference() {
        rounded_cube_xy([eSizeY, eZ - eSizeZ + fillet + eps, eSizeX], 3);
        if (!left)
            // cutouts for zipties
            for (y = idlerUprightZipTiePositions())
                translate([eSizeY, y, eSizeX+eps])
                    rotate([0, 90, 0])
                        zipTieCutout();
    }
    // idler upright, top part, xSize matches idler
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width));
    translate([0, middleWebOffsetZ(), 0])
        rounded_cube_xy([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness, eSizeX], fillet);
    // idler upright reinforcement to stop front face shear
    rounded_cube_xy([frontReinforcementThickness(), coreXYPosBL(NEMA_width, yCarriageType()).z - coreXYSeparation().z/2 - idlerBracketSize.y, idlerBracketSize.z], fillet);
    translate([frontReinforcementThickness(), coreXYPosBL(NEMA_width, yCarriageType()).z - idlerBracketSize.x-1.5, 0])
        rotate(270)
            fillet(fillet, idlerBracketSize.z);
    translate([0, eZ -eSizeZ-2*fillet, 0]) {
        rounded_cube_xy([idlerBracketSize.x, eSizeZ + 2*fillet - _topPlateThickness, _backFaceHoleInset + 4], fillet);
        rounded_cube_xy([_backPlateThickness, eSizeZ + 2*fillet, _backFaceHoleInset + 4], fillet);
    }
}

module frameLower(NEMA_width, left=true, offset=0, cf=false) {
    translate([eY + 2*eSizeY - motorUprightWidth, 0, offset]) {
        difference() {
            size = [motorUprightWidth, middleWebOffsetZ(), eSizeXBase - offset];
            union() {
                translate([0, eSizeZ, 0])
                    rounded_cube_xy(size, fillet);
                // small cube for back face boltholes
                translate([0, middleWebOffsetZ(), 0]) {
                    rounded_cube_xy([eSizeY, eSizeZ, _backFaceHoleInset + 4 - offset], fillet);
                    if (offset==0)
                        translate([-eSizeY, 0, 0])
                            cube([2*eSizeY, eSizeZ, eSizeX], fillet);
                }
            }
            // cutouts for zipties
            for (y = motorUprightZipTiePositions())
                translate([-eps, y, size.z])
                    zipTieCutout();
            translate([eSizeZ, backFaceHolePositions()[1], _backFaceHoleInset - offset])
                rotate([90, 0, -90])
                    boltHoleM3Tap(backBoltLength, horizontal = !cf, chamfer_both_ends=false);
        }
    }

    difference() {
        // bottom chord
        union() {
            translate([offset, 0, offset])
                rounded_cube_xy([eY + 2*eSizeY - offset, eSizeZ, eSizeXBase - offset], fillet);
            translate([eY + 2*eSizeY - 10, 0, offset])
                rounded_cube_xy([10, 20, 35 - offset], fillet); // 38 to match frontConnector size
        }
        translate([eY + 2*eSizeY, backFaceHolePositions()[0], _backFaceHoleInset])
            rotate([90, 0, -90])
                boltHoleM3Tap(backBoltLength, horizontal = !cf, chamfer_both_ends=false);
        translate([eY + 2*eSizeY, backFaceBracketLowerOffset().y, backFaceBracketLowerOffset().x])
            rotate([90, 0, -90])
                boltHoleM3Tap(10, horizontal = !cf, chamfer_both_ends=false);
        for (x = bottomChordZipTiePositions(left))
            translate([x, eSizeY+eps, eSizeX + 2])
                rotate(-90)
                    zipTieCutout();
        lowerChordHolePositions()
            rotate([90, 0, 180])
                // !! changing bolthole length can cause STL file to become invalid
                // try setting bolt length to eSizeZ -1 to fix.
                //boltHoleM3TapOrInsert(eSizeZ - 2, horizontal=true);
                //boltHoleM3TapOrInsert(eSizeZ, horizontal=true, chamfer_both_ends=true);
                translate_z(-eps)
                    poly_cylinder(r=M3_tap_radius, h=eSizeZ - 2, sides=6);
    }
    translate([eY + eSizeY, eSizeZ, offset])
        rotate(90)
            fillet(innerFillet, eSizeXBase - offset);
}

module frontConnector() {
    overlap = faceConnectorOverlap();
    overlapHeight = faceConnectorOverlapHeight();
    size = [eSizeY, frontLowerChordSize().y, idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z + overlap];

    difference() {
        translate_z(_sidePlateThickness)
            rounded_cube_xy(size - [0, 0, _sidePlateThickness], fillet);
            translate([-eps, -eps, size.z - overlap])
                cube([overlapHeight, size.y + 2*eps, overlap + 2*eps]);

            for (y = [5, size.y/2, size.y - 5])
                translate([size.x, y, size.z - overlap/2])
                    rotate([90, 0, -90])
                        boltHoleM3TapOrInsert(size.x - overlapHeight, horizontal=true, chamfer_both_ends=true);
    }
}


//use coordinate frame of flat frame
module frame(NEMA_type, left=true) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);

    idlerUpright(NEMA_width, left);
    difference() {
        union() {
            frameLower(NEMA_width, left);
            // cube for top face bolt holes
            topBoltHolderSize = topBoltHolderSize(0);
            translate([0, eZ - _topPlateThickness - topBoltHolderSize.y, 0]) {
                translate([_frontPlateCFThickness, 0, 0])
                    rounded_cube_xy(topBoltHolderSize, fillet);
                translate([idlerBracketSize(coreXYPosBL(NEMA_width)).x, 0, 0])
                    rotate(270)
                        fillet(2, topBoltHolderSize.z);
            }
            motorUpright(NEMA_width, left);

            frontConnector();
            // middle chord
            translate([0, middleWebOffsetZ(), 0])
                cube([eY + eSizeY+eps, eSizeZ, eSizeX]);
        }
        sideFaceTopHolePositions()
            //boltHoleM3Tap(topBoltHolderSize().y - 1, horizontal=true);
            boltHoleM3Tap(topBoltHolderSize().y, horizontal=true, chamfer_both_ends=true);
        faceConnectorHolePositions()
            rotate([90, 0, 180])
                boltHoleM3TapOrInsert(backBoltLength, _useInsertsForFaces, horizontal=true);
        // add some holes to access the motor bolts
        translate([coreXYPosTR(NEMA_width).y, eZ - yRailSupportThickness()+eps, coreXYPosBL(NEMA_width).x + coreXY_drive_pulley_x_alignment(coreXY_type())])
            rotate([-90, -90, 0])
                NEMA_screw_positions(NEMA_type)
                    rotate([180, 0, 90])
                        translate([-M3_clearance_radius, -2.6, 0])
                            cube([2*M3_clearance_radius, 5, 10]);
        // middle chord
        if (!left)// add cutouts for extruder motor wires
            for (y = extruderZipTiePositions())
                translate([y + extruderPosition(NEMA_width).y, middleWebOffsetZ() - eps, eSizeX])
                    rotate(90)
                        zipTieCutout();
    }

    // fillets

    // middle
    translate([eSizeY, middleWebOffsetZ(), 0]) {
        rotate(-90)
            fillet(innerFillet, eSizeX);
        translate([eY, 0, 0])
            rotate(180)
                fillet(innerFillet, eSizeX);
        if (left)
            translate([idlerBracketSize(coreXYPosBL(NEMA_width)).x - eSizeY, eSizeZ, 0])
                fillet(innerFillet, eSizeX); // fillet not needed on right side because of spoolholder
        translate([eY + eSizeY - motorClearance().y + upperFillet, eSizeZ, 0])
            rotate(90)
                fillet(3, eSizeX);// smaller fillet by motor cutout
    }

    // lower
    translate([eSizeY, eSizeZ, 0])
        fillet(innerFillet, eSizeXBase);
}

function extruderZipTiePositions() = [10, 48];
function motorUprightZipTiePositions() = [30, middleWebOffsetZ() - 18];
function idlerUprightZipTiePositions() = [middleWebOffsetZ() - 20];
function bottomChordZipTiePositions(left) = left ? [eY/2 + eSizeY + 30, eY + 2*eSizeY - 30] : [eY + 2*eSizeY - 30];

module zipTieCutout() {
    cutoutSize = [5, 4, 2];
    cutoutDepth = cutoutSize.x/2;

    translate([0, -cutoutSize.y/2, - cutoutSize.z - cutoutDepth]) {
        difference() {
            union() {
                translate([-eps, 0, 0])
                    cube(cutoutSize + [eps, 0, 0]);
                translate([cutoutSize.x - cutoutSize.z, 0, 0])
                    cube([cutoutSize.z, cutoutSize.y, cutoutSize.z + cutoutDepth + 2*eps]);
            }
            // add a fillet to make it easier to insert the ziptie
            translate([cutoutSize.x + eps, -eps, -eps])
                rotate([90, 0, 180])
                    fillet(2, cutoutSize.y + 2*eps); // rounded fillet seems to work better than triangular one
                    //right_triangle(1, 1, cutoutSize.y + 2*eps, center=false);
        }
    }
}

module leftAndRightFaceZipTies(left) {
    translate([eY + 2*eSizeY - motorUprightWidth, 0, 0])
        for (y = motorUprightZipTiePositions())
            translate([0.5, y, eSizeXBase])
                rotate(90)
                    cable_tie(cable_r = 3, thickness = 3);
    for (x = bottomChordZipTiePositions(left))
        translate([x, eSizeY - 1, eSizeX + 1])
            rotate(180)
                cable_tie(cable_r = 3, thickness = 2);
}

module rightFaceExtruderZipTies(NEMA_width) {
    for (y = extruderZipTiePositions())
        translate([eX + eSizeX, y + extruderPosition(NEMA_width).y, middleWebOffsetZ() + 0.5])
            rotate([90, 0, -90])
                cable_tie(cable_r = 3, thickness = 3);
}

module rightFaceIdlerUprightZipTies() {
    for (y = idlerUprightZipTiePositions())
        translate([eSizeY, y, eSizeX+eps])
            rotate([0, 0, -90])
                cable_tie(cable_r = 3, thickness = 3);
}
