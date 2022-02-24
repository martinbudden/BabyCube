include <../global_defs.scad>

include <../vitamins/bolts.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../utils/carriageTypes.scad>
include <../utils/HolePositions.scad>

include <../vitamins/inserts.scad>

include <../Parameters_CoreXY.scad>


function yRailSupportSize(NEMA_width = _xyNEMA_width)
    = [ eY + 2*eSizeY, yRailSupportThickness(), yRailOffset(NEMA_width).x + rail_width(railType(_yCarriageDescriptor))/2 + 1 ];

function idlerBracketSize(coreXYPosBL=[0, 0, 0]) = [coreXYPosBL.y + 6, 6, floor(coreXYPosBL.x/2)*2 + 10];
function idlerBracketTopSizeY() = 11;
function idlerBracketTopSizeZ() = 25;

function faceConnectorOverlap() = 10;
function faceConnectorOverlapHeight() = 4;
function frontUpperChordSize() = [eX + 2*eSizeX - 2*idlerBracketTopSizeZ(), 21, eSizeY + 1];
function frontLowerChordSize() = [eX + 2*eSizeX - 2*idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z, 50, eSizeY];

module XY_Idler_Bracket_Left_stl() {
    NEMA_width = NEMA_width(NEMA14_36);

    stl("XY_Idler_Bracket_Left")
        color(pp1_colour)
            XY_IdlerBracket(coreXYPosBL(NEMA_width), NEMA_width, _sidePlateThickness, useCNC=true);
}

module XY_Idler_Bracket_Right_stl() {
    NEMA_width = NEMA_width(NEMA14_36);

    stl("XY_Idler_Bracket_Right")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_IdlerBracket(coreXYPosBL(NEMA_width), NEMA_width, _sidePlateThickness, useCNC=true);
}

module XY_Idler_Bracket_Left_NEMA_17_stl() {
    NEMA_width = NEMA_width(NEMA17);

    stl("XY_Idler_Bracket_Left_NEMA_17")
        color(pp1_colour)
            XY_IdlerBracket(coreXYPosBL(NEMA_width), NEMA_width, _sidePlateThickness, useCNC=true);
}

module XY_Idler_Bracket_Right_NEMA_17_stl() {
    NEMA_width = NEMA_width(NEMA17);

    stl("XY_Idler_Bracket_Right_NEMA_17")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_IdlerBracket(coreXYPosBL(NEMA_width), NEMA_width, _sidePlateThickness, useCNC=true);
}

module XY_Idler_Bracket_Left_assembly()
assembly("XY_Idler_Bracket_Left", ngb=true) {

    NEMA_width = NEMA_width(NEMA14_36);
    yCarriageType = carriageType(_yCarriageDescriptor);
    translate_z(coreXYPosBL(NEMA_width, yCarriageType).z + coreXYSeparation().z)
        rotate([90, 0, 90])
            stl_colour(pp1_colour)
                if (_xyMotorDescriptor == "NEMA14")
                    XY_Idler_Bracket_Left_stl();
                else
                    XY_Idler_Bracket_Left_NEMA_17_stl();
    rotate([90, 0, 90])
        XY_IdlerBracketHardware(coreXYPosBL(NEMA_width, yCarriageType));
}

module XY_Idler_Bracket_Right_assembly()
assembly("XY_Idler_Bracket_Right", ngb=true) {

    NEMA_width = NEMA_width(NEMA14_36);
    coreXYPosBL = coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor));
    translate([eX + 2*eSizeX, 0, coreXYPosBL.z + coreXYSeparation().z])
        rotate([-90, 0, 90])
            stl_colour(pp1_colour)
                if (_xyMotorDescriptor == "NEMA14")
                    XY_Idler_Bracket_Right_stl();
                else
                    XY_Idler_Bracket_Right_NEMA_17_stl();
    translate([eX + 2*eSizeX, 0, 0])
        rotate([90, 0, 90])
            vflip()
                mirror([0, 1, 0])
                    XY_IdlerBracketHardware(coreXYPosBL);
}

module XY_IdlerBracketCutouts(coreXYPosBL) {
    sizeY = idlerBracketSize(coreXYPosBL).y;
    separation = coreXYSeparation().z();

    translate([coreXYPosBL.y, coreXYPosBL.z, coreXYPosBL.x])
        translate([0, separation, 0])
            rotate([-90, 180, 0])
                boltHoleM3TapOrInsert(sizeY, horizontal=true);
}

module idlerBracketHolePositions(coreXYPosBL, offset) {
    size = idlerBracketSize(coreXYPosBL) - [offset, 0, 0];
    separation = coreXYSeparation().z;
    if (offset) {
        translate([0, -2*separation + yCarriageBraceThickness() - size.y])
            translate([size.x/2, size.y/2, 0])
                children();
        translate([size.x/2, idlerBracketTopSizeY()/2, 0])
            children();
    }
}

module xyIdlerBracketHolePositions(NEMA_width) {
    coreXYPosBL = coreXYPosBL(NEMA_width);
    translate([3, coreXYPosBL.z + 10, 0])
        idlerBracketHolePositions(coreXYPosBL, _sidePlateThickness)
            children();
}

module idlerBracket(coreXYPosBL, NEMA_width, offset=0) {
    fillet = 1.5;
    size = idlerBracketSize(coreXYPosBL) - [offset, 0, 0];
    separation = coreXYSeparation().z;

    boltPos = [-coreXYPosBL.y + offset, coreXYPosBL.x - _sidePlateThickness, 0];
    cutout = offset ? false : true;

    translate([0, -2*separation + yCarriageBraceThickness() - size.y])
        difference() {
            rounded_cube_xy(size - [0, 0, _sidePlateThickness], fillet);
            rotate([-90, 180, 0])
                translate(boltPos)
                    boltHoleM3(size.y, horizontal=true, chamfer=1);
        }
    overlap = faceConnectorOverlap();
    topSize = [size.x, idlerBracketTopSizeY(), overlap + idlerBracketTopSizeZ() - _sidePlateThickness];
    difference() {
        cutoutDepth = cutout ? faceConnectorOverlapHeight() : 0;
        if (cutout) {
            union() {
                rounded_cube_xy([topSize.x, topSize.y, topSize.z - overlap], fillet);
                translate([cutoutDepth, 0, 0])
                    rounded_cube_xy([topSize.x - cutoutDepth, topSize.y, topSize.z], fillet);
            }
        } else {
            rounded_cube_xy(topSize, fillet);
        }

        translate([cutoutDepth, topSize.y/2, topSize.z - overlap/2])
            rotate([0, 90, 0])
                boltHoleM3Tap(topSize.x - cutoutDepth, horizontal=true, rotate=90, chamfer_both_ends=true);
        rotate([-90, 180, 0])
            translate(boltPos)
                boltHoleM3TapOrInsert(topSize.y - 2, horizontal=true, chamfer_both_ends=false);
    }
    // base
    translate([0, -2*separation - size.y + 2*fillet, 0])
        cube([size.x, 2*(separation + size.y), 5]);
}

module XY_IdlerBracket(coreXYPosBL, NEMA_width, offset=0, useCNC=false) {
    //size = idlerBracketSize(coreXYPosBL) - [offset, 0, 0];

    //boltPos = [coreXYPosBL.y - offset, 0, coreXYPosBL.x - _sidePlateThickness];
    //baseLength = eZ - coreXYPosBL.z + separation + size.y - yRailSupportSize(NEMA_width).y;
    translate([offset, -yCarriageBraceThickness()/2, _sidePlateThickness])
        difference() {
            idlerBracket(coreXYPosBL, NEMA_width, offset);
            idlerBracketHolePositions(coreXYPosBL, offset)
                boltHoleM3Tap(12);
    }
    if (useCNC) {
        size = [45, topBoltHolderSize().y, topBoltHolderSize().z];
        fillet = 1;
        offsetY = 9.5;
        difference() {
            translate([_frontPlateCFThickness, offsetY, _sidePlateThickness])
                union() {
                    rounded_cube_xy(size, _fillet);
                    size2 = [eSizeY, 4*fillet, size.z];
                    translate([0, -size2.y + 2*fillet, 0])
                        cube(size2);
                    size3 = [eSizeY, 25, eSizeZ];
                    translate([0, -size3.y - 30, 0])
                        rounded_cube_xy(size3, 1.5);
                }
            translate([_sidePlateThickness, -eZ + 160.5, (eSizeX + _sidePlateThickness)/2])
                rotate([0, 90, 0])
                    boltHoleM3Tap(eSizeZ, horizontal=true, rotate=90, chamfer_both_ends=true);
            translate([0, size.y + offsetY, eX + 2*eSizeX])
                rotate([90, 90, 0])
                    topFaceSideHolePositions()
                        boltHoleM3Tap(8, horizontal = true, rotate = 90, chamfer_both_ends = false);
            translate([0, 30 - eZ - offsetY, 0])
                upperSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(size.z);
        }
    }
}

module XY_IdlerBracketHardware(coreXYPosBL) {
    size = idlerBracketSize(coreXYPosBL);
    boltPos = [coreXYPosBL.y, coreXYPosBL.x, 1];
    separation = coreXYSeparation().z;

    translate([0, coreXYPosBL.z, 0])
        rotate([-90, 0, 0]) {
            translate([boltPos.x, -boltPos.y, -separation - size.y - 1])
                vflip()
                    boltM3Countersunk(screw_shorter_than(2*separation + idlerBracketTopSizeY() + size.y));
            for (z = [0, -separation])
                translate([boltPos.x, -boltPos.y, z + yCarriageBraceThickness()/2])
                    explode([-40, 0, 0], true)
                        washer(M3_washer)
                            explode([20, 0, 0], true)
                                pulley(coreXY_toothed_idler(coreXY_type()))
                                    explode([-20, 0, 0])
                                        washer(M3_washer);
            if (yCarriageBraceThickness())
                translate([boltPos.x, -boltPos.y, -washer_thickness(M3_washer)])
                    explode([-40, 5, 0], true)
                        washer(M3_washer)
                            explode([0, -10, 0])
                                washer(M3_washer);
        }
}

module idlerBracketThreadedInsert(size, boltPos) {
    separation = pulley_height(GT2x16_toothed_idler) + 2*washer_thickness(M3_washer);
    if (_useInsertsForFaces)
        translate([boltPos.x, separation, boltPos.z])
            rotate([90, 0, 0])
                explode(10)
                    _threadedInsertM3();
}

module XY_IdlerBracketThreadedInsert(coreXYPosBL) {
    size = idlerBracketSize(coreXYPosBL);

    boltPos = [coreXYPosBL.y, 0, coreXYPosBL.x];

    translate([0, coreXYPosBL.z, 0])
        idlerBracketThreadedInsert(size, boltPos);
}
