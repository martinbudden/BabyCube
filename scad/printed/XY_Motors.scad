include <../global_defs.scad>

include <../vitamins/bolts.scad>

use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../utils/carriageTypes.scad>
include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

include <../vitamins/CorkDamper.scad>

include <../Parameters_Main.scad>


// NEMA 14 with longer shaft, to ensure clearances
//NEMA14= ["NEMA14",   35.2, 36,     46.4/2, 21,     11,     2,     5,     21,          26,    [8,     8]];
NEMA14T = ["NEMA14T",   35.2, 36,     46.4/2, 21,     11,     2,     5,     24,          26,    [8,     8], 3,     false, false, 0,       0];
NEMA17_48 = ["NEMA17_48",     42.3, 48,     53.6/2, 25,     11,     2,     5,     24,          31,    [11.5,  9], 3,     false, false, 0,       0];

function NEMA14T() = NEMA14T;

function xyMotorType() =
    _xyMotorDescriptor == "NEMA14" ? NEMA14T :
    _xyMotorDescriptor == "NEMA17" ? NEMA17_40 :
    _xyMotorDescriptor == "NEMA17_47" ? NEMA17_47 :
    _xyMotorDescriptor == "NEMA17_48" ? NEMA17_48 :
    undef;


basePlateThickness = _xyMotorBracketThickness;
pulleyOffset = pulley_height(GT2x20ob_pulley) - pulley_hub_length(GT2x20ob_pulley);

//function motorUprightThickness() = eSizeY - 5;

function XY_MotorMountSize(NEMA_width, basePlateThickness=basePlateThickness, cf=false) = [
    floor(NEMA_width) + motorClearance().x - _sidePlateThickness,
    NEMA_width + motorClearance().y + (cf ? 3.5 : 0.5),
    basePlateThickness
];

function xyMotorPosition(NEMA_width, left) = [
    eX + 2*eSizeX - coreXYPosTR(NEMA_width).x + (useReversedBelts() ?  0 : coreXY_drive_pulley_x_alignment(coreXY_type())) + (left ? leftDrivePulleyOffset().x : -rightDrivePulleyOffset().x),
    coreXYPosTR(NEMA_width).y + (left ? leftDrivePulleyOffset().y : rightDrivePulleyOffset().y),
    coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor)).z - motorClearance().z - pulleyOffset - (left ? coreXYSeparation().z/2 : -coreXYSeparation().z/2)
];


/*function xyMotorPosition(NEMA_width, left) = [
    coreXYPosTR(NEMA_width).y,
    coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor)).z - pulleyOffset + (left ? -coreXYSeparation().z/2 : coreXYSeparation().z/2) - motorClearance().z,
    eX + 2*eSizeX - coreXYPosTR(NEMA_width).x + coreXY_drive_pulley_x_alignment(coreXY_type())
];*/

module XY_MotorPosition(NEMA_width, left=true) {
    //offset = eZ - coreXYPosBL(NEMA_width, carriageType(_yCarriageDescriptor)).z + basePlateThickness + (left ? 0 : coreXYSeparation().z);
    rotate([-90, -90, 0])
        translate(xyMotorPosition(NEMA_width, left))
            children();
}

module XY_MotorUpright(NEMA_type, left=true) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);

    XY_MotorPosition(NEMA_width, left)
        //render_if(!$preview, convexity=10)
            XY_MotorMount(NEMA_type, left, basePlateThickness, eZ - xyMotorPosition(NEMA_width, left).z);
}

module XY_MotorUprightHardware(NEMA_type, left=true) {
    assert(isNEMAType(NEMA_type));
    NEMA_width = NEMA_width(NEMA_type);

    XY_MotorPosition(NEMA_width, left)
        XY_MotorMountHardware(NEMA_type, basePlateThickness);
}

module xyMotorMountBackHolePositions(left=true, z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (pos = [[10, 10], [37, 38]])
        translate(left ? [pos.x, size.y - pos.y, z] : [size.x - pos.x, size.y - pos.y, z])
            children();
}


module xyMotorMountTopHolePositions(left=true, z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    x = _useReversedBelts ? 46/2 + 4 : 46/2;
    y = _useReversedBelts ? 189 : 190;
    for (pos = left ? [[_useReversedBelts ? _sidePlateThickness + 2.5 : topFaceSideHolePositionOffset(), y], [_sidePlateThickness + x, size.y - 2.5]] 
                    : [[size.x - (_useReversedBelts ? _sidePlateThickness + 2.5 :topFaceSideHolePositionOffset()), y], [size.x - _sidePlateThickness - x, size.y - 2.5]] 
        )
        translate([pos.x, pos.y, z])
            children();
}

function xyMotorMountSideHolePositions(sizeY) = [ [-4, 0], [-sizeY + 4, 0], [-4, 18] ];

module xyMotorMountSideHolePositions() {
    translate([eY + 2*eSizeY, eZ])
        for (pos = [[-10, -15], [-35, -38]])
            translate(pos)
                children();
}

module XY_MotorMount(NEMA_type, left=true, basePlateThickness=basePlateThickness, offset=0, cf=false) {
    assert(isNEMAType(NEMA_type));
    assert(offset >= yRailSupportThickness());

    NEMA_width = NEMA_width(NEMA_type);
    size = XY_MotorMountSize(NEMA_width, cf=cf);
    fillet = 1.5;
    braceWidth = 3;
    braceHeight = offset - yRailSupportThickness();
    backBraceThickness = 7;
    offsetY = 0;

    difference() {
        // baseplate for motor with cutouts
        union() {
            yRailType = railType(_yCarriageDescriptor);
            translate([-NEMA_width/2 - motorClearance().x + _sidePlateThickness, NEMA_width/2 + motorClearance().y - size.y, 0]) {
                if (cf) {
                    rounded_cube_xy(size + [0, offsetY*2, 0], fillet);
                    translate([0, size.y - backBraceThickness, 0]) {
                        rounded_cube_xy([size.x, backBraceThickness, braceHeight - rail_height(yRailType) - 1], fillet);
                        // small cube for back face boltholes
                        rounded_cube_xy([10, backBraceThickness, braceHeight], fillet);
                    }
                } else {
                    rounded_cube_yz(size + [0, offsetY*2, 0], fillet);
                    translate([0, size.y - backBraceThickness, 0]) {
                        rounded_cube_yz([NEMA_type == NEMA14T() ? size.x :  32.5 + motorClearance().x - _sidePlateThickness,
                                        backBraceThickness,
                                        _fullLengthYRail ? braceHeight - rail_height(yRailType) - 1 : braceHeight], fillet);
                        if (NEMA_type == NEMA17_40)
                            rounded_cube_yz([size.x, backBraceThickness, 18], fillet);
                        // small cube for back face boltholes
                        rounded_cube_yz([10, backBraceThickness, braceHeight], fillet);
                    }
                }
            }
        }
        translate_z(-eps)
            rotate(-90)
                if (cf)
                    poly_cylinder(r=NEMA_boss_radius(NEMA_type) + 0.5, h=basePlateThickness + 2*eps);
                else
                    teardrop(basePlateThickness + 2*eps, NEMA_boss_radius(NEMA_type) + 0.5, center=false, chamfer=0.5);
        translate_z(basePlateThickness)
            NEMA_screw_positions(NEMA_type)
                rotate([180, 0, 90])
                    boltHoleM3(basePlateThickness, horizontal=!cf);

        *if (cf)
            translate([-NEMA_width/2 - motorClearance().x + _sidePlateThickness,NEMA_width/2 + motorClearance().y, basePlateThickness/2])
                rotate([90, 0, 90])
                    for (pos = xyMotorMountSideHolePositions(size.y))
                        translate(pos)
                            boltHoleM3Tap(10, horizontal=true, chamfer_both_ends=false);

        translate([-NEMA_width/2 - motorClearance().x + _sidePlateThickness, NEMA_width/2 + motorClearance().y - backBraceThickness, 0]) {
                        translate([_backFaceHoleInset - _sidePlateThickness, 0, offset - (eZ - backFaceHolePositions()[2])])
                            rotate([90, 0, 180])
                                boltHoleM3Tap(backBraceThickness, horizontal=true, rotate=cf ? 0 : 90);
                        //upperOffsetX = (eX + 2*eSizeX - backUpperChordSize().z)/2 + 5;
                        translate([backFaceBracketUpperOffset().x - _sidePlateThickness, 0, offset - backFaceBracketUpperOffset().y])
                            rotate([90, 0, 180])
                                boltHoleM3Tap(backBraceThickness, horizontal=true, rotate=cf ? 0 : 90);
        }

        *translate([NEMA_width/2, NEMA_width/2+motorClearance().y, 0])
            rotate([90, 0, -90])
                fillet(fillet, size.x);
    }
}

module XY_MotorMountHardware(NEMA_type, basePlateThickness=basePlateThickness, corkDamperThickness=_corkDamperThickness) {
    assert(isNEMAType(NEMA_type));

    pulley_type = GT2x20um_pulley;
    rotate(-90)
        explode(-30, true)
            translate_z(-corkDamperThickness) {
                NEMA(NEMA_type, jst_connector=true);
                if (corkDamperThickness)
                    explode(15)
                        corkDamper(NEMA_type, corkDamperThickness);
            }
    explode(10)
        translate_z(pulleyOffset - pulley_offset(pulley_type) + motorClearance().z)
            vflip()
                pulley(pulley_type);
    explode(20, true)
        translate_z(basePlateThickness)
            NEMA_screw_positions(NEMA_type)
                boltM3Caphead(screw_shorter_than(5 + basePlateThickness + corkDamperThickness));
}

