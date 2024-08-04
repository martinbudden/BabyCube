include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../utils/carriageTypes.scad>
include <../utils/cutouts.scad>
include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

function yRailSupportSize(NEMA_width)
    = [ eY + 2*eSizeY, yRailSupportThickness(), yRailOffset(NEMA_width).x + rail_width(railType(_yCarriageDescriptor))/2 + 1 ];

//bearingType = BB608;

cutoutFront = 11.75;
cutoutBack = 42.5;
cutoutXExtra = 6;


module topFace(NEMA_type, useReversedBelts) {
    topFaceCover(NEMA_type, useReversedBelts);
    topFaceInterlock(NEMA_type, useReversedBelts);
}

module topFaceCF(NEMA_type, extraY) {
    insetY = _backPlateCFThickness - extraY;
    size = [eX + 2*eSizeX, eY + 2*eSizeY + extraY, yRailSupportThickness()];

    difference() {
        sheet_2D(CF3, size.x, size.y);
        translate([-size.x/2, -size.y/2 - insetY])
            topFaceInterlockCutouts(NEMA_type, M3_clearance_radius, useReversedBelts=true, cnc=true);
    }
}

module topFaceCover(NEMA_type, useReversedBelts=false) {
    assert(isNEMAType(NEMA_type));
    assert(_variant != "BC200CF" && _variant != "BC220CF"); // cover not used for CF, and won't draw properly if _variant erroneously set

    NEMA_width = NEMA_width(NEMA_type);
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _topPlateCoverThickness];
    cutoutX = 2*floor(yRailSupportSize(NEMA_width).z/2) + cutoutXExtra;
    cutoutFrontY = cutoutFront;
    cutoutBackY = cutoutBack;
    cutoutSize = [size.x - 2*cutoutX, size.y - cutoutFrontY - cutoutBackY, size.z + 2*eps];
    //insetY = _backPlateThickness;

    difference() {
        linear_extrude(size.z)
            difference() {
                rounded_square([size.x, size.y], _fillet, center=false);
                //translate([(size.x - cutoutSize.x)/2, cutoutFrontY + insetY])
                translate([(size.x - cutoutSize.x)/2,  cutoutFrontY, -eps])
                    rounded_square([cutoutSize.x, cutoutSize.y], 4, center=false);
                topFaceFrontHolePositions(useJoiner=false)
                    poly_circle(r=M3_clearance_radius);
                topFaceBackHolePositions()
                    poly_circle(r=M3_clearance_radius);
                topFaceSideHolePositions()
                    poly_circle(r=M3_clearance_radius);
                if (useReversedBelts) {
                    xyMotorMountTopHolePositions(left=true)
                        poly_circle(r=M3_clearance_radius);
                    xyMotorMountTopHolePositions(left=false)
                        poly_circle(r=M3_clearance_radius);
                } else {
                    motorAccessHolePositions(NEMA_type)
                        poly_circle(r=M3_clearance_radius);
                }
                zRodHolePositions()
                    poly_circle(r=_zRodDiameter/2 + 0.5);
                zLeadScrewHolePosition()
                    poly_circle(r=_zLeadScrewDiameter/2 + 1);
                topFaceWiringCutout(NEMA_width, printheadWiringPos());
            }
        topFaceRailHolePositions(NEMA_width)
            boltHoleM3Tap(size.z - 0.5, twist=0);
    }
}

module topFaceWiringCutout(NEMA_width, printheadWiringPos) {
    cutoutBackY = cutoutBack - _backPlateThickness;
    size = [6.5 + eps, cutoutBackY - (eY + 2*eSizeY - printheadWiringPos.y) + eps];
    fillet = 5;
    radius = 5;

    translate([printheadWiringPos.x, printheadWiringPos.y]) {
        circle(r=radius);
        translate([-size.x/2, -size.y]) {
            square(size, center=false);
            translate([size.x, -eps]) {
                fillet(NEMA_width < 40 ? 5 : 1);
                translate([-size.x, 0])
                    rotate(90)
                        fillet(fillet);
            }
        }
    }
}

module topFaceInterlock(NEMA_type, useReversedBelts=false) {
    assert(isNEMAType(NEMA_type));

    insetY = 3;
    size = [eX + 2*eSizeX, eY + 2*eSizeY + insetY, yRailSupportThickness()];

    translate_z(-size.z)
        linear_extrude(size.z)
            difference() {
                rounded_square([size.x, size.y], _fillet, center=false);
                topFaceInterlockCutouts(NEMA_type, M3_tap_radius, useReversedBelts=useReversedBelts, cnc=false);
            }
    if (!is_undef(bearingType))
        translate_z(-bb_width(bearingType))
            linear_extrude(bb_width(bearingType) - size.z)
                zLeadScrewHolePosition()
                    difference() {
                        poly_circle(r=bb_diameter(bearingType)/2 + 3);
                        poly_circle(r=bb_diameter(bearingType)/2);
                    }

    insetX = idlerBracketTopSizeZ() + (_fullLengthYRail ? 0 : 3) + (_xyMotorDescriptor == "NEMA14" ? 0 : 3);
    endStopSize = [faceConnectorOverlap() - (_fullLengthYRail ? 0 : 3), 5, 8];
    for (x= [insetX, eX + 2*eSizeX - endStopSize.x - insetX],
        y = [faceConnectorOverlapHeight(), eY + 2*eSizeY - endStopSize.y - (_fullLengthYRail ? 0 : 8)])
            translate([x, y, -endStopSize.z])
                rounded_cube_xy(endStopSize, 1);
}

module motorAccessHolePositions(NEMA_type, n=3) {
    assert(isNEMAType(NEMA_type));

    NEMA_width = NEMA_width(NEMA_type);
    yCarriageType = carriageType(_yCarriageDescriptor);
    for (x = [coreXYPosBL(NEMA_width, yCarriageType).x + coreXY_drive_pulley_x_alignment(coreXY_type()), coreXYPosTR(NEMA_width, yCarriageType).x - coreXY_drive_pulley_x_alignment(coreXY_type())])
        translate([x, coreXYPosTR(NEMA_width, yCarriageType).y])
            if (x < eX/2)
                NEMA_screw_positions(NEMA_type, n)
                    children();
            else if (NEMA_width < 40)
                mirror([1, 0, 0])
                    NEMA_screw_positions(NEMA_type, n)
                        children();
            else
                rotate(270)
                    NEMA_screw_positions(NEMA_type, 2)
                        children();
}

module cutout_circle(r, cnc) {
    if (cnc)
        circle(r=r);
    else
        poly_circle(r=r);
}

module topFaceInterlockCutouts(NEMA_type, railHoleRadius=M3_clearance_radius, useReversedBelts=false, cnc=false) {
    assert(isNEMAType(NEMA_type));

    NEMA_width = NEMA_width(NEMA_type);
    insetX = 3;
    insetY = _backPlateThickness - 1;
    size = [eX + 2*eSizeX, eY + 2*eSizeY, yRailSupportThickness()];

    cutoutX = 2 * floor(yRailSupportSize(NEMA_width).z/2) + cutoutXExtra;
    cutoutFrontY = cutoutFront - insetY + (cnc ? 2 : 0);
    cutoutBackY = cutoutBack - _backPlateThickness + insetY;
    cutoutSize = [size.x - 2*cutoutX, size.y - cutoutFrontY - cutoutBackY, size.z + 2*eps];

    translate([(size.x - cutoutSize.x)/2, cutoutFrontY + insetY])
        rounded_square([cutoutSize.x, cutoutSize.y], 4, center=false);

    topFaceRailHolePositions(NEMA_width, step = cnc ? 2 : 1)
        cutout_circle(railHoleRadius, cnc);

    topFaceFrontHolePositions(useJoiner=cnc)
        cutout_circle(M3_clearance_radius, cnc);
    topFaceBackHolePositions()
        cutout_circle(M3_clearance_radius, cnc);
    topFaceSideHolePositions()
        cutout_circle(M3_clearance_radius, cnc);

    zRodHolePositions()
        cutout_circle(_zRodDiameter/2 + 0.5, cnc);

    zLeadScrewHolePosition()
        if (is_undef(bearingType))
            poly_circle(r=_zLeadScrewDiameter/2 + 1);
        else
            poly_circle(r=bb_diameter(bearingType)/2);

    if (useReversedBelts) {
        xyMotorMountTopHolePositions(left=true)
            cutout_circle(M3_clearance_radius, cnc);
        xyMotorMountTopHolePositions(left=false)
            cutout_circle(M3_clearance_radius, cnc);
    } else {
        motorAccessHolePositions(NEMA_type)
            cutout_circle(M3_clearance_radius, cnc);
    }

    topFaceWiringCutout(NEMA_width, printheadWiringPos());

    // remove the sides and back
    topFaceSideCutouts(cnc);
    topFaceFrontCutouts(cnc, NEMA_width);
    topFaceBackCutouts(cnc, NEMA_width);
}

module railHolePositions(type, length, step=1) { //! Position children over screw holes
    pitch = rail_pitch(type);
    holeCount = rail_holes(type, length);
    for(i = [0 : step : holeCount - 1])
        translate([i * pitch - length / 2 + (length - (holeCount - 1) * pitch) / 2, 0])
            children();
}

module topFaceRailHolePositions(NEMA_width, step=1) {
    railOffset = yRailOffset(NEMA_width);
    yRailType = railType(_yCarriageDescriptor);
    for (x = [railOffset.x, eX + 2*eSizeX - railOffset.x])
        translate([x, railOffset.y, 0])
            rotate(90)
                railHolePositions(yRailType, _yRailLength, step=step)
                //rail_hole_positions(yRailType, _yRailLength, first=0, screws=rail_holes(yRailType, _yRailLength))
                    children();
}

module topFaceSideCutouts(cnc=false) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    insetX = 3;
    insetY = _backPlateThickness;

    translate([0, insetY])
        topFaceSideDogbones(cnc);

    translate([size.x, insetY])
        topFaceSideDogbones(cnc);
}

module topFaceFrontCutouts(cnc, NEMA_width) {
    fillet = 1;
    extraX = _xyMotorDescriptor == "NEMA14" ? 0 : 6;
    size = [eX + 2*eSizeX - 2*idlerBracketTopSizeZ() - extraX, _backPlateThickness + 2*fillet];

    offsetX = (eX + 2*eSizeX - size.x)/2;
    if (cnc) {
        yRailOffset = yRailOffset(NEMA_width).x - (rail_width(railType(_yCarriageDescriptor)) + 3)/2;
        topFaceFrontAndBackDogbones(cnc, yRailOffset=yRailOffset);
    } else {
        translate([offsetX, -2*fillet])
            rounded_square(size, 0, center=false);
        cornerCutoutSize = [12 + extraX, size.y];
        for (x = [0, eX + 2*eSizeX - cornerCutoutSize.x])
            translate([x, -2*fillet])
                rounded_square(cornerCutoutSize, 1, center=false);
        translate([offsetX, 0])
            rotate(90)
                fillet(fillet);
        translate([offsetX + size.x, 0])
            fillet(fillet);
        translate([cornerCutoutSize.x, 0])
            fillet(fillet);
        translate([eX + 2*eSizeX - cornerCutoutSize.x, 0])
            rotate(90)
                fillet(fillet);
        translate([_sidePlateThickness, _backPlateThickness])
            fillet(fillet);
        translate([eX + 2*eSizeX - _sidePlateThickness, _backPlateThickness])
            rotate(90)
                fillet(fillet);
    }
}

module topFaceBackCutouts(cnc, NEMA_width) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    insetX = 3;
    insetY = 3;
    yRailOffset = yRailOffset(NEMA_width).x - (rail_width(railType(_yCarriageDescriptor)) + 3)/2;

    translate([0, size.y + insetY])
        topFaceFrontAndBackDogbones(cnc, yRailOffset=yRailOffset);
    if (!cnc) {
        translate([insetX, size.y])
            rotate(-90)
                fillet(1);
        translate([size.x - insetX, size.y])
            rotate(180)
                fillet(1);
    }
}
