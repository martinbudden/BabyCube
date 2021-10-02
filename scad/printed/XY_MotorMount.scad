include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../utils/carriageTypes.scad>
include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

include <../vitamins/bolts.scad>
include <../vitamins/CorkDamper.scad>

include <../Parameters_Main.scad>


// NEMA 14 with longer shaft, to ensure clearances
//NEMA14= ["NEMA14",   35.2, 36,     46.4/2, 21,     11,     2,     5,     21,          26,    [8,     8]];
NEMA14T = ["NEMA14T",   35.2, 36,     46.4/2, 21,     11,     2,     5,     24,          26,    [8,     8], 3,     false, false, 0,       0];
function NEMA14T() = NEMA14T;

function xyMotorType() =
    _xyMotorDescriptor == "NEMA14" ? NEMA14T :
    _xyMotorDescriptor == "NEMA17" ? NEMA17M :
    undef;


basePlateThickness = _xyMotorBracketThickness;
pulleyOffset = pulley_height(GT2x20ob_pulley) - pulley_hub_length(GT2x20ob_pulley);

//function motorUprightThickness() = eSizeY - 5;

function XY_MotorMountSize(NEMA_width, basePlateThickness=basePlateThickness, cf=false) = [
    floor(NEMA_width) + motorClearance().x - _sidePlateThickness,
    NEMA_width + motorClearance().y + 1.5 + (cf ? 2 : 0),
    basePlateThickness
];

function xyMotorPosition(NEMA_width, left) = [
    eX + 2*eSizeX - coreXYPosTR(NEMA_width).x + coreXY_drive_pulley_x_alignment(coreXY_type()),
    coreXYPosTR(NEMA_width).y,
    coreXYPosBL(NEMA_width, yCarriageType(_yCarriageDescriptor)).z - motorClearance().z - pulleyOffset - (left ? coreXYSeparation().z/2 : -coreXYSeparation().z/2)
];


/*function xyMotorPosition(NEMA_width, left) = [
    coreXYPosTR(NEMA_width).y,
    coreXYPosBL(NEMA_width, yCarriageType(_yCarriageDescriptor)).z - pulleyOffset + (left ? -coreXYSeparation().z/2 : coreXYSeparation().z/2) - motorClearance().z,
    eX + 2*eSizeX - coreXYPosTR(NEMA_width).x + coreXY_drive_pulley_x_alignment(coreXY_type())
];*/

module XY_Motor_Mount_Left_stl() {
    NEMA_type = NEMA14T;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left")
        color(pp1_colour)
            XY_MotorMount(NEMA_type, left=true, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=true).z, cf=true);
}

module XY_Motor_Mount_Right_stl() {
    NEMA_type = NEMA14T;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_MotorMount(NEMA_type, left=false, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=false).z, cf=true);
}

module XY_Motor_Mount_Left_NEMA_17_stl() {
    NEMA_type = NEMA17M;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left_NEMA_17")
        color(pp1_colour)
            XY_MotorMount(NEMA_type, left=true, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=true).z, cf=true);
}

module XY_Motor_Mount_Right_NEMA_17_stl() {
    NEMA_type = NEMA17M;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right_NEMA_17")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_MotorMount(NEMA_type, left=false, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=false).z, cf=true);
}

module XY_Motor_Mount_Left_assembly()
assembly("XY_MotorMount_Left", big=true, ngb=true) {

    NEMA_type = xyMotorType();
    NEMA_width = NEMA_width(NEMA_type);

    translate([-eps, 0, 0])
        rotate([90, 0, 90])
            XY_MotorPosition(NEMA_width, left=true) {
                stl_colour(pp1_colour)
                    if (_xyMotorDescriptor == "NEMA14")
                        XY_Motor_Mount_Left_stl();
                    else
                        XY_Motor_Mount_Left_NEMA_17_stl();
                XY_MotorMountHardware(NEMA_type);
            }
}

module XY_Motor_Mount_Right_assembly()
assembly("XY_Motor_Mount_Right", big=true, ngb=true) {

    NEMA_type = xyMotorType();
    NEMA_width = NEMA_width(NEMA_type);

    translate([eX + 2 * eSizeX - NEMA_width - _sidePlateThickness - 1, 0, 0])
        rotate([90, 0, 90])
            XY_MotorPosition(NEMA_width, left=false)
                rotate(180) {
                    stl_colour(pp1_colour)
                        if (_xyMotorDescriptor == "NEMA14")
                            XY_Motor_Mount_Right_stl();
                        else
                            XY_Motor_Mount_Right_NEMA_17_stl();
                    XY_MotorMountHardware(NEMA_type);
                }
}

module XY_MotorPosition(NEMA_width, left=true) {
    //offset = eZ - coreXYPosBL(NEMA_width, yCarriageType(_yCarriageDescriptor)).z + basePlateThickness + (left ? 0 : coreXYSeparation().z);
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

function xyMotorMountHolePositions(sizeY) = [ [-4, 0], [-sizeY + 4, 0], [-4, 18] ];

module xyMotorMountHolePositions(NEMA_width, left) {
    zPos = xyMotorPosition(NEMA_width, left).z;
    size = XY_MotorMountSize(NEMA_width, cf=true);
    translate([eY + 2*eSizeY, zPos + 3])
        for (pos = xyMotorMountHolePositions(size.y))
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
    backBraceThickness = 8;
    offsetY = 0;

    difference() {
        // baseplate for motor with cutouts
        union() {
            yRailType = yRailType(_yCarriageDescriptor);
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
                        if (NEMA_type == NEMA17M)
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
                    poly_cylinder(r = NEMA_boss_radius(NEMA_type) + 0.5, h = basePlateThickness + 2*eps);
                else
                    teardrop(basePlateThickness + 2*eps, NEMA_boss_radius(NEMA_type) + 0.5, center=false, chamfer=0.5);
        translate_z(basePlateThickness)
            NEMA_screw_positions(NEMA_type)
                rotate([180, 0, 90])
                    boltHoleM3(basePlateThickness, horizontal = !cf);

        if (cf)
            translate([-NEMA_width/2 - motorClearance().x + _sidePlateThickness,NEMA_width/2 + motorClearance().y, basePlateThickness/2])
                rotate([90, 0, 90])
                    for (pos = xyMotorMountHolePositions(size.y))
                        translate(pos)
                            boltHoleM3Tap(10, horizontal=true, chamfer_both_ends=false);

        translate([-NEMA_width/2 - motorClearance().x + _sidePlateThickness, NEMA_width/2 + motorClearance().y - backBraceThickness, 0]) {
                        translate([_backFaceHoleInset - _sidePlateThickness, 0, offset - (eZ - backFaceHolePositions()[2])])
                            rotate([90, 0, 180])
                                boltHoleM3Tap(backBraceThickness, horizontal=true, rotate = cf ? 0 : 90);
                        //upperOffsetX = (eX + 2*eSizeX - backUpperChordSize().z)/2 + 5;
                        translate([backFaceBracketUpperOffset().x - _sidePlateThickness, 0, offset - backFaceBracketUpperOffset().y])
                            rotate([90, 0, 180])
                                boltHoleM3Tap(backBraceThickness, horizontal=true, rotate = cf ? 0 : 90);
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
        explode(-30, true) {
            translate_z(-corkDamperThickness) {
                NEMA(NEMA_type, jst_connector = true);
                if (corkDamperThickness)
                    explode(15)
                        corkDamper(NEMA_type, corkDamperThickness);
            }
            translate_z(pulleyOffset - pulley_offset(pulley_type) + motorClearance().z)
                vflip()
                    pulley(pulley_type);
        }
    explode(50)
        translate_z(basePlateThickness)
            NEMA_screw_positions(NEMA_type)
                boltM3Buttonhead(screw_shorter_than(5 + basePlateThickness + corkDamperThickness));
}
