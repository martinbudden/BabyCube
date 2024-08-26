include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/vitamins/psu.scad> // for psu_grill
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/rockers.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/carriageTypes.scad>
include <../utils/cutouts.scad>
include <../utils/diagonal.scad>
include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

include <../vitamins/inserts.scad>

use <SpoolHolder.scad>
use <SwitchShroud.scad>
use <XY_IdlerBracket.scad>
include <XY_MotorMountRB.scad>
include <IECHousing.scad>


function iecPosition() = [eX + 2*eSizeX, eY + 2*eSizeY - eSizeY - 1 - iec_body_h(iecType())/2, eSizeZ/2 + iec_pitch(iecType())/2] + [0, -10, 8];
function rightFaceFanPosition(fan, offset) = [eX + 2*eSizeX - fan_depth(fan)/2 + offset.x, fan_width(fan)/2 + offset.y, fan_width(fan)/2 + eSizeZ];

function extruderMotorType() = NEMA17_40;

function backBoltLength() = 9;

fanOffsetRB = [-1, eSizeY + 40];

fillet = _fillet;
innerFillet = 5;
upperWebThickness = 3;
antiShearSize = [eY + 2*eSizeY, 20];
switchShroudSizeX = 60;//switchShroudSize().x;
upperFillet = 1.5;
motorClearance = motorClearance(reversedBelts=_useReversedBelts, cnc=_useCNC);

function rocker_type() = small_rocker;
function rockerPosition(rocker_type) = [0, rocker_height(rocker_type)/2 + frontLowerChordSize().y + 3, eSizeX + eps + rocker_slot_w(rocker_type)/2];
function extruderMotorOffsetZ() = upperWebThickness;
//ECHO: extruderPosition14Y = 132
//ECHO: extruderPosition17Y = 117.8
//function extruderPosition(NEMA_width) = [eX + 2*eSizeX, eY - 2*NEMA_width + 2*35.2 - 40 - motorClearance.y, eZ - 73];
function extruderPosition(NEMA_width) = [eX + 2*eSizeX, eY - motorClearance.y - NEMA_width - (NEMA_width < 40 ? 3.8 : 2.7), eZ - 73];
function spoolHolderPosition(cf=false) = [eX + 2*eSizeX + (cf ? 10 : 0), cf ? 25 : 24, cf ? eZ - 70 : eZ - 75];
function frontReinforcementThickness() = 3;
function spoolHolderBracketSize(cf=false) = [cf ? 3 : eSizeX, cf ? 25 : 30, 20];


module leftFace(NEMA_type, useFrontSwitch=false, fullyEnclosed=false, reversedBelts=false, fan=false) {
    assert(isNEMAType(NEMA_type));

    difference() {
        union() {
            frame(NEMA_type, left=true, useFrontSwitch=useFrontSwitch, reversedBelts=reversedBelts);
            webbingLeft(NEMA_type, useFrontSwitch=useFrontSwitch, fullyEnclosed=fullyEnclosed, reversedBelts=reversedBelts, fan=fan);
            NEMA_width = NEMA_width(NEMA_type);
            coreXYPosBL = coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor));
            translate([0, coreXYPosBL.z + coreXYSeparation().z, 0])
                XY_IdlerBracket(coreXYPosBL, NEMA_width, offset=0, reversedBelts=reversedBelts, left=true, cnc=false);
            // add a support for the camera
            translate([0, coreXYPosBL.z - coreXYSeparation().z, 0])
                translate([3, -5, eSizeX])
                    rotate([90, 0, 0])
                        right_triangle(9, 9, 20, center=false);
            XY_MotorUpright(NEMA_type, left=true, reversedBelts=reversedBelts);
        }
        if (useFrontSwitch) {
            switchShroudHolePositions()
                boltPolyholeM3Countersunk(eSizeXBase, sink=0.25);
            translate(rockerPosition(rocker_type())) {
                rockerHoleSize = [frontReinforcementThickness() + 2*eps, rocker_slot_h(rocker_type()), rocker_slot_w(rocker_type())];
                translate([-eps, -rockerHoleSize.y/2, -rockerHoleSize.z/2]) {
                    cube(rockerHoleSize);
                    // add cutout to avoid bridging bug in slic3r/PrusaSlicer/SuperSlicer
                    translate([rockerHoleSize.x/2, 0, rockerHoleSize.z - eps]) {
                        //cube([rockerHoleSize.x/2, rockerHoleSize.y, 0.5 + eps]);
                        translate([rockerHoleSize.x/2, 0, 0])
                            rotate([90, 0, 180])
                                right_triangle(rockerHoleSize.x/2, 1 + eps, rockerHoleSize.y, center=false);
                    }
                }
            }
        }
    }
}

module rightFace(NEMA_type, useIEC=false, fullyEnclosed=false, reversedBelts=false, fan=false) {
    assert(isNEMAType(NEMA_type));

    // orient the right face for printing
    rotate(180)
        mirror([0, 1, 0])
            difference() {
                union() {
                    frame(NEMA_type, left=false, useFrontSwitch=false, reversedBelts=reversedBelts);
                    webbingRight(NEMA_type, useIEC=useIEC, fullyEnclosed=fullyEnclosed, reversedBelts=reversedBelts, fan=fan);
                    NEMA_width = NEMA_width(NEMA_type);
                    coreXYPosBL = coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor));
                    translate([0, coreXYPosBL.z + coreXYSeparation().z, 0])
                        XY_IdlerBracket(coreXYPosBL, NEMA_width, offset=0, reversedBelts=reversedBelts, left=false, cnc=false);
                    XY_MotorUpright(NEMA_type, left=false, reversedBelts=reversedBelts);
                }
                if (fullyEnclosed)
                    translate([spoolHolderPosition(cf=true).y, spoolHolderPosition(cf=true).z - 20, 0])
                        spoolHolderBracketHolePositions(M3=true) {
                            boltHoleM3(eSizeX);
                            nut = M3_nut;
                            translate_z(eSizeX + eps)
                                vflip()
                                    linear_extrude(nut_thickness(nut) + 0.5 + 2*eps)
                                        circle(r=nut_radius(nut) + 0.1, $fn=6);
                        }
            }
}

module sideFaceMotorCutout(left, NEMA_width, cnc=true, zOffset=0) {
    cutoutHeight = NEMA_width < 40 ? 40 : 50;
    translate([coreXYPosTR(NEMA_width).y, xyMotorPosition(NEMA_width, left).z + zOffset, 0])
        motorCutout([NEMA_width + 3, cutoutHeight, cnc ? 0 : _webThickness], upperFillet);
}

module motorCutout(size, upperFillet) {
    lowerFillet = 3;
    if (size.z == 0)
        translate([-size.x/2, -size.y]) {
            translate([0, lowerFillet*2])
                rounded_square([size.x, size.y - lowerFillet*2], upperFillet, center=false);
            rounded_square([size.x, size.y - lowerFillet*2 - 1], lowerFillet, center=false);
        }
    else
        translate([-size.x/2, -size.y, -2*eps]) {
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
        sideFaceTopDogbones(toolType=P3D, plateThickness=_topPlateThickness);
    }
}

module webbingLeft(NEMA_type, useFrontSwitch=false, fullyEnclosed=false, reversedBelts=false, fan=false) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);
    left = true;
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width));

    // not needed as covered by diagonal
    *translate([idlerBracketSize.x, eZ - antiShearSize.y, 0])
        rotate(-90)
            fillet(innerFillet, upperWebThickness);

    // shroud for switch
    if (useFrontSwitch) {
        translate([eSizeX - fillet, 0, 0])
            cube([switchShroudSizeX - eSizeX + fillet, middleWebOffsetZ(), _webThickness]);
        *translate([switchShroudSizeX, eSizeZ, 0]) // not needed, since covered by diagonal
            fillet(innerFillet, _webThickness);
        translate([switchShroudSizeX, middleWebOffsetZ(), 0])
            rotate(-90)
                fillet(innerFillet, _webThickness);
    }
    // upright by motor
    uprightPos = [coreXYPosTR(NEMA_width).y - 3 - NEMA_width/2 - eSizeY, middleWebOffsetZ(), 0];
    linear_extrude(upperWebThickness)
        difference() {
            union() {
                translate(uprightPos)
                    square([eY + 2*eSizeY - uprightPos.x, eZ - yRailSupportThickness() - middleWebOffsetZ() - dogBoneCNCBitRadius]);
                antiShearBracing(NEMA_width);
                translate([uprightPos.x, eZ - antiShearSize.y])
                    rotate(180)
                        fillet(innerFillet);
                // idler upright
                rounded_square([eSizeY, eZ - eSizeZ + fillet], 1.5, center=false);
                translate([0, middleWebOffsetZ(), 0])
                    rounded_square([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness], fillet, center=false);
                if (_sideTabs)
                    sideFaceBackTabs();
            }
            if (!reversedBelts)
                sideFaceMotorCutout(left, NEMA_width);
        }
    // diagonal brace by motor
    motorDiagonalSize = [uprightPos.x - idlerBracketSize.x, eZ - eSizeZ - middleWebOffsetZ()-antiShearSize.y, upperWebThickness];
    translate([idlerBracketSize.x, middleWebOffsetZ() + eSizeZ, 0])
        //diagonalDown([uprightPos.x - idlerBracketSize.x, middleWebOffsetZ() - 35 - eSizeZ, _webThickness], min(eSizeY, eSizeZ), 5, extend=true);
        diagonalDown(motorDiagonalSize, min(eSizeY, eSizeZ), innerFillet);
    if (fullyEnclosed)
        translate([eSizeY - 1, middleWebOffsetZ() + eSizeZ - 1, 0])
            cube([motorDiagonalSize.x + eSizeY + 2, motorDiagonalSize.y + 2, 1]);

    // main diagonal brace
    diagonalSize  = [eY + eSizeY - (useFrontSwitch ? switchShroudSizeX : 2*eSizeY), middleWebOffsetZ() - eSizeZ, _webThickness];
    translate([(useFrontSwitch ? switchShroudSizeX : 2*eSizeY), eSizeZ, 0])
        diagonal(diagonalSize, min(eSizeY, eSizeZ), innerFillet);
    if (fullyEnclosed)
        translate([eSizeY - 1, eSizeZ - 1, 0])
            cube([diagonalSize.x + eSizeY + 2, diagonalSize.y + 2, 1]);

    translate([(useFrontSwitch ? switchShroudSizeX : eSizeY), baseCoverOutsideHeight, 0])
        fillet(innerFillet, diagonalSize.z);
    // panel to enclose side under base cover
    translate([eSizeY, 0, 0]) {
        linear_extrude(1)
            difference() {
                square([eY, baseCoverOutsideHeight]);

                fanWidth = 30;
                offsetY = 72;
                if (reversedBelts)
                    translate([fanWidth/2 + offsetY, fanWidth/2 + eSizeZ - 2])
                        rotate(90)
                            psu_grill(25, 30, grill_hole=3, grill_gap=1, fn=6, avoid=[]);
            }
        translate([0, baseCoverOutsideHeight, 0]) {
            translate([eY, 0, 0])
                rotate(90)
                    fillet(innerFillet, diagonalSize.z);
        }
        translate([0, baseCoverInsideHeight, 0])
            cube([eY, baseCoverOutsideHeight - baseCoverInsideHeight, diagonalSize.z]);
        cube([eSizeY, baseCoverOutsideHeight, diagonalSize.z]); // to fill in fillet on base cover attachment point
        translate([eSizeY, baseCoverInsideHeight, 0])
            rotate(-90)
                fillet(innerFillet, diagonalSize.z);
        translate([eY, baseCoverInsideHeight, 0])
            rotate(180)
                fillet(innerFillet, diagonalSize.z);
    }
}

module spoolHolderCutout(NEMA_width, cnc=false) {

    width = (extruderPosition(NEMA_width).y - XY_MotorMountSize(NEMA_width).y)/2;
    if (cnc)
        translate([spoolHolderPosition(cnc).y - spoolHolderBracketSize(cnc).z/2, spoolHolderPosition(cnc).z])
            rounded_square([30, eZ - antiShearSize.y - spoolHolderPosition().z], innerFillet, center=false);
    else
        translate([idlerBracketSize(coreXYPosBL(NEMA_width)).x, spoolHolderPosition().z])
            rounded_square([extruderPosition(NEMA_width).y - width/2 - eSizeY-idlerBracketSize(coreXYPosBL(NEMA_width)).x, eZ - antiShearSize.y - spoolHolderPosition().z], innerFillet, center=false);
}

module webbingRight(NEMA_type, useIEC=false, fullyEnclosed=false, reversedBelts=false, fan=false) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);
    left = false;
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width));

    // main diagonal brace
    iecPanelSize = [65, middleWebOffsetZ(), 3];
    iecOffset  = (useIEC ? iecPanelSize.x : 0);
    diagonalSize = [eY + 2*eps - iecOffset,
                    middleWebOffsetZ() - baseCoverOutsideHeight + 2*eps,
                    useIEC ? iecPanelSize.z : _webThickness];
    translate([eSizeY + eps, baseCoverOutsideHeight - eps, 0]) // eps displacement probably not necessary
        diagonalDown(diagonalSize, min(eSizeY, eSizeZ), innerFillet);
    // panel to enclose side under base cover
    translate([eSizeY, 0, 0]) {
        //cube([eY - iecOffset, baseCoverOutsideHeight, 1]);
        linear_extrude(1)
            difference() {
                square([eY - iecOffset, baseCoverOutsideHeight]);

                if (fan) {
                    fan_type = fan30x10;
                    translate([fan_width(fan_type)/2 + fanOffsetRB.y - eSizeY, fan_width(fan_type)/2 + eSizeZ]) {
                        poly_circle(r=fan_bore(fan_type)/2 - 0.5);
                        fan_hole_positions(fan_type)
                            poly_circle(r=M3_clearance_radius);
                    }
                }
            }

        translate([0, baseCoverInsideHeight, 0])
            cube([eY - iecOffset, baseCoverOutsideHeight - baseCoverInsideHeight, diagonalSize.z]);
        cube([eSizeY, baseCoverOutsideHeight, diagonalSize.z]); // to fill in fillet on base cover attachment point
        translate([eSizeY, baseCoverInsideHeight, 0])
            rotate(-90)
                fillet(innerFillet, diagonalSize.z);
        translate([eY -iecOffset, baseCoverInsideHeight, 0])
            rotate(180)
                fillet(innerFillet, diagonalSize.z);
    }

    if (fullyEnclosed)
        translate([eSizeY - 1, eSizeZ - 1, 0])
            cube([diagonalSize.x + 2, middleWebOffsetZ() + 2, 1]);
    if (useIEC)
        difference() {
            translate([eY + eSizeY - iecPanelSize.x, 0, 0]) {
                cube(iecPanelSize);
                translate([0, iecPanelSize.y, 0])
                    rotate(180)
                        fillet(innerFillet, iecPanelSize.z);
            }
            translate([iecPosition().y, iecPosition().z, 0]) {
                cutoutSize = [48, 30, iecPanelSize.z + 2*eps];
                for(y = [-iec_pitch(iecType())/2, iec_pitch(iecType())/2]){
                    translate_z(-eps)
                        rounded_cube_xy(cutoutSize, 5, xy_center=true);
                    translate([0, y, 0])
                        boltHoleM3(iecPanelSize.z);
                }
            }
        }

    extruderPosition = extruderPosition(NEMA_width);
    width = (extruderPosition.y - XY_MotorMountSize(NEMA_width).y)/2;
    // plate to hold extruder
    difference() {
        union() {
            linear_extrude(upperWebThickness)
                difference() {
                    union() {
                        translate([0, middleWebOffsetZ()])
                            //square([eY + eSizeY - XY_MotorMountSize(NEMA_width).y + eps, eZ - middleWebOffsetZ() - _topPlateThickness]);
                            square([eY + 2*eSizeY, eZ - middleWebOffsetZ() - _topPlateThickness - dogBoneCNCBitRadius]);
                        antiShearBracing(NEMA_width);
                        // idler upright
                        rounded_square([eSizeY, eZ - eSizeZ + fillet], 3, center=false);
                        translate([0, middleWebOffsetZ(), 0])
                            rounded_square([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness], fillet, center=false);
                        if (_sideTabs)
                            sideFaceBackTabs();
                    }// end union
                    translate([extruderPosition.y, extruderPosition.z]) {
                        poly_circle(r=NEMA_boss_radius(extruderMotorType()) + 0.25);
                        // extruder motor bolt holes
                        NEMA_screw_positions(extruderMotorType())
                            poly_circle(r=M3_clearance_radius);
                    }
                    if (!fullyEnclosed)
                        spoolHolderCutout(NEMA_width);
                    if (!reversedBelts)
                        sideFaceMotorCutout(left, NEMA_width);
                }// end difference
            // support for the spoolholder
            translate([0, middleWebOffsetZ(), 0]) {
                offset = 22.5;
                rounded_cube_xy([extruderPosition.y - offset - eSizeY + innerFillet, spoolHolderPosition().z - middleWebOffsetZ(), eSizeX], innerFillet);
                translate([extruderPosition.y - offset - eSizeY + innerFillet, eSizeZ, 0])
                    fillet(innerFillet, eSizeX);
            }
        }// end union
        if (fullyEnclosed)
            translate_z(1)
                linear_extrude(upperWebThickness - 1 + 2*eps)
                    spoolHolderCutout(NEMA_width);
    }// end difference

    // support for the spoolholder
    translate([idlerBracketSize.x, spoolHolderPosition().z, 0])
        fillet(innerFillet, eSizeX);

    // blocks to prevent the spoolholder from twisting
    if (!fullyEnclosed)
        translate([0, middleWebOffsetZ(), 0]) {
            translate([idlerBracketSize.x + spoolHolderBracketSize().z + 0.25, 0, 0])
                rounded_cube_xy([10, spoolHolderPosition().z - middleWebOffsetZ(), eSizeX + 5], 2);
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

module motorUpright(NEMA_width, left, reversedBelts) {
    //uprightTopZ = coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor)).z - (left ? coreXYSeparation().z : 0);
    uprightTopZ = reversedBelts ? eZ - _topPlateThickness - xyMotorMountRBSize(NEMA_width).z + 2*fillet : xyMotorPosition(NEMA_width, left).z + 2*fillet;
    uprightPosZ = middleWebOffsetZ() + eSizeZ - 2*fillet;
    upperFillet = 1.5;
    translate([eY + 2*eSizeY - motorClearance.y + upperFillet, uprightPosZ, 0])
        cube([motorClearance.y - upperFillet, uprightTopZ - uprightPosZ, eSizeXBase]);
}

module idlerUpright(NEMA_width, left, reversedBelts) {
    difference() {
        rounded_cube_xy([eSizeY, eZ - eSizeZ + fillet + eps, eSizeX], 3);
        if (!left)
            // cutouts for zipties
            for (y = idlerUprightZipTiePositions())
                translate([eSizeY, y, eSizeX + eps])
                    rotate([0, 90, 0])
                        zipTieCutout();
    }
    // idler upright, top part, xSize matches idler
    rightReversedBeltOffset = reversedBelts && !left ? coreXYSeparation().z : 0; // right sized idler bracket is smaller for reversed belts
    idlerBracketSize = idlerBracketSize(coreXYPosBL(NEMA_width)) + [0, -rightReversedBeltOffset, 0];
    translate([0, middleWebOffsetZ(), 0])
        rounded_cube_xy([idlerBracketSize.x, eZ - middleWebOffsetZ() - _topPlateThickness, eSizeX], fillet);
    // idler upright reinforcement to stop front face shear
    coreXYPosBL = coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor));
    translate([0, eSizeZ, 0])
        rounded_cube_xy([frontReinforcementThickness(), coreXYPosBL.z - coreXYSeparation().z/2 - idlerBracketSize.y - eSizeZ, idlerBracketSize.z], fillet);
    translate([frontReinforcementThickness(), coreXYPosBL.z - idlerBracketSize.x - 2 + rightReversedBeltOffset, 0])
        rotate(270)
            fillet(1.5, idlerBracketSize.z);
    translate([0, eZ - eSizeZ - 5, 0]) {
        extraZ = _xyMotorDescriptor == "NEMA14" ? 4 : 10;
        rounded_cube_xy([idlerBracketSize.x, eSizeZ + 5 - _topPlateThickness, _backFaceHoleInset + extraZ], fillet);
        rounded_cube_xy([_backPlateThickness, eSizeZ + 5, _backFaceHoleInset + extraZ], fillet);
    }
}

module frameLower(NEMA_width, left=true, offset=0, length=0, useFrontSwitch=false) {
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
                    boltHoleM3Tap(backBoltLength(), horizontal=true, chamfer_both_ends=false);
        }
    }

    difference() {
        // bottom chord
        union() {
            fillet = 1.5;
            translate([length == 0 ? offset : eY + 2*eSizeY - length, 0, offset])
                rounded_cube_xy([length == 0 ? eY + 2*eSizeY - offset : length, eSizeZ, eSizeXBase - offset], fillet);
            translate([eY + 2*eSizeY - 10, 0, offset])
                rounded_cube_xy([10, 20, 35 - offset], fillet); // 38 to match frontConnector size
            if (!useFrontSwitch || !left) {
                // attachment point for base cover
                difference() {
                    rounded_cube_xy([2*eSizeY, baseCoverInsideHeight, eSizeXBase - offset], fillet);
                    translate([offset + 3*eSizeY/2, baseCoverInsideHeight, (eSizeXBase + offset)/2 + 2])
                        rotate([90, 0, 0])
                            boltHoleM3Tap(10);
                }
            }
        }
        translate([eY + 2*eSizeY, backFaceHolePositions()[0], _backFaceHoleInset])
            rotate([90, 0, -90])
                boltHoleM3Tap(backBoltLength(), horizontal=true, chamfer_both_ends=false);
        translate([eY + 2*eSizeY, backFaceBracketLowerOffset().y, backFaceBracketLowerOffset().x])
            rotate([90, 0, -90])
                boltHoleM3Tap(10, horizontal=true, chamfer_both_ends=false);
        for (x = bottomChordZipTiePositions(left))
            translate([x, eSizeY + eps, eSizeX + 2])
                rotate(-90)
                    zipTieCutout();
        lowerChordHolePositions()
            rotate([90, 0, 180])
                // !! changing bolthole length can cause STL file to become invalid
                // try setting bolt length to eSizeZ -1 to fix.
                //boltHoleM3TapOrInsert(eSizeZ - 2, horizontal=true);
                //boltHoleM3TapOrInsert(eSizeZ, horizontal=true, chamfer_both_ends=true);
                boltHoleM3Tap(eSizeZ - 2, horizontal=true, chamfer_both_ends=false);
                *translate_z(-eps)
                    poly_cylinder(r=M3_tap_radius, h=eSizeZ - 2, sides=6);
    }
    // back fillet
    translate([eY + eSizeY, eSizeZ, offset])
        rotate(90)
            fillet(innerFillet, eSizeXBase - offset);
    // front fillet
    translate([useFrontSwitch ? eSizeY : 2*eSizeY, eSizeZ, 0])
        fillet(innerFillet, eSizeXBase);
}

module frontConnector() {
    overlap = faceConnectorOverlap();
    overlapHeight = faceConnectorOverlapHeight();
    size = [eSizeY, frontLowerChordSize().y, idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z + overlap];

    fillet = 1.5;
    difference() {
        translate_z(_sidePlateThickness)
            union() {
                rounded_cube_xy([size.x, size.y, size.z - _sidePlateThickness - overlap], fillet);
                translate([overlapHeight, 0, 0])
                    rounded_cube_xy([size.x - overlapHeight, size.y, size.z - _sidePlateThickness], fillet);
            }
            for (y = [5, size.y/2, size.y - 5])
                translate([size.x, y, size.z - overlap/2])
                    rotate([90, 0, -90])
                        boltHoleM3TapOrInsert(size.x - overlapHeight, horizontal=true, chamfer_both_ends=true);
    }
}


//use coordinate frame of flat frame
module frame(NEMA_type, left=true, useFrontSwitch=false, reversedBelts=false) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);
    topBoltHolderSize = topBoltHolderSize(0, reversedBelts=reversedBelts);

    idlerUpright(NEMA_width, left, reversedBelts);
    difference() {
        union() {
            frameLower(NEMA_width, left, useFrontSwitch=useFrontSwitch);
            // cube for top face bolt holes
            topBoltHolderSize = topBoltHolderSize;
            translate([0, eZ - _topPlateThickness - topBoltHolderSize.y, 0]) {
                translate([_frontPlateCFThickness, 0, 0])
                    rounded_cube_xy(topBoltHolderSize, fillet);
                translate([idlerBracketSize(coreXYPosBL(NEMA_width)).x, 0, 0])
                    rotate(270)
                        fillet(2, topBoltHolderSize.z);
            }
            motorUpright(NEMA_width, left, reversedBelts);

            frontConnector();
            // middle chord
            translate([0, middleWebOffsetZ(), 0])
                cube([eY + eSizeY + eps, eSizeZ, eSizeX]);
        }
        sideFaceTopHolePositions()
            boltHoleM3Tap(topBoltHolderSize.y, horizontal=true, chamfer_both_ends=true);
        faceConnectorHolePositions()
            rotate([90, 0, 180])
                boltHoleM3TapOrInsert(backBoltLength(), _useInsertsForFaces, horizontal=true);
        // add a holes to access a motor bolt
        translate([coreXYPosTR(NEMA_width).y, eZ - yRailSupportThickness() + eps, coreXYPosBL(NEMA_width).x + coreXY_drive_pulley_x_alignment(coreXY_type())])
            rotate([-90, 90, 0])
                NEMA_screw_positions(NEMA_type, n=1)
                    rotate([180, 0, 90])
                        translate([-M3_clearance_radius, -2.6, 0]) {
                            size = [2*M3_clearance_radius, 5, 8 + 2*eps];
                            cube(size);
                            rotate([-90, 180, 0])
                                fillet(fillet, size.y);
                            translate([size.x, 0, 0])
                                rotate([-90, -90, 0])
                                    fillet(fillet, size.y);
                            translate([size.x, 0, size.z])
                                rotate([-90, 0, 0])
                                    fillet(fillet, size.y);
                            translate([0, 0, size.z])
                                rotate([-90, 90, 0])
                                    fillet(fillet, size.y);
                        }
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
        translate([eY + eSizeY - motorClearance.y + upperFillet, eSizeZ, 0])
            rotate(90)
                fillet(3, eSizeX);// smaller fillet by motor cutout
    }
}

function extruderZipTiePositions() = [10, 48];
function idlerUprightZipTiePositions() = [middleWebOffsetZ() - 20];
function bottomChordZipTiePositions(left) = left ? [eY/2 + eSizeY + 30, eY + 2*eSizeY - 30] : [eY + 2*eSizeY - 30];

module leftAndRightFaceZipTies(left, lowerZipTies=true) {
    translate([eY + 2*eSizeY - motorUprightWidth, 0, 0])
        for (y = motorUprightZipTiePositions())
            translate([0.5, y, eSizeXBase])
                rotate(90)
                    cable_tie(cable_r=3, thickness=3);
    if (lowerZipTies)
        for (x = bottomChordZipTiePositions(left))
            translate([x, eSizeY - 1, eSizeX + 1])
                rotate(180)
                    cable_tie(cable_r=3, thickness=2);
}

module rightFaceExtruderZipTies(NEMA_width) {
    for (y = extruderZipTiePositions())
        translate([eX + eSizeX, y + extruderPosition(NEMA_width).y, middleWebOffsetZ() + 0.5])
            rotate([90, 0, -90])
                cable_tie(cable_r=3, thickness=3);
}

module rightFaceIdlerUprightZipTies() {
    for (y = idlerUprightZipTiePositions())
        translate([eSizeY, y, eSizeX + eps])
            rotate([0, 0, -90])
                cable_tie(cable_r=3, thickness=3);
}
