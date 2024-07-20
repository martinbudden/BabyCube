include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <../utils/motorTypes.scad>
include <XY_Motors.scad>


basePlateThickness = 4;

function XY_MotorMountCFSize(NEMA_width, basePlateThickness) = [
    floor(NEMA_width),
    floor(NEMA_width) + 8,
    basePlateThickness
];

module XY_MotorMountCF(NEMA_type, left, basePlateThickness, height) {
    assert(isNEMAType(NEMA_type));

    NEMA_width = NEMA_width(NEMA_type);
    size = XY_MotorMountCFSize(NEMA_width, basePlateThickness);
    sideSize = [5, size.y - 9, height];
    backSize = [size.x, 5, height];
    fillet = 1;

    difference() {
        translate_z(eZ - _topPlateThickness - height)
            union() {
                // baseplate for motor with cutouts
                translate([ left ? _sidePlateThickness : eX + 2*eSizeX - _sidePlateThickness - size.x, eY + 2*eSizeY, 0]) {
                    translate([0, -size.y, 0])
                        rounded_cube_xy(size, fillet);
                    translate([left ? 0 : size.x - sideSize.x, -sideSize.y, 0])
                        rounded_cube_xy(sideSize, fillet);
                    translate([0, -backSize.y, 0])
                        rounded_cube_xy(backSize, fillet);
                }
            }
        translate_z(eZ - _topPlateThickness - height) {
            translate([left ? coreXYPosBL(NEMA_width).x : coreXYPosTR(NEMA_width).x, coreXYPosTR(NEMA_width).y]) {
                boltHoleM3Tap(basePlateThickness);
                translate(left ? leftDrivePulleyOffset() : rightDrivePulleyOffset()) {
                    translate_z(-eps)
                        poly_cylinder(r=NEMA_boss_radius(NEMA_type) + 0.5, h=basePlateThickness + 2*eps);
                    NEMA_screw_positions(NEMA_type)
                        boltHoleM3(basePlateThickness);
                }
            }
        }
        translate([left ? _sidePlateThickness : eX + 2*eSizeX - _sidePlateThickness, 0, 0])
            rotate([90, 0, 90])
                xyMotorMountSideHolePositions()
                    vflip(!left)
                        boltHoleM3Tap(sideSize.x, horizontal=true);
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0])
                xyMotorMountBackHolePositions(left)
                    boltHoleM3Tap(backSize.y, horizontal=true);
        xyMotorMountTopHolePositions(left, eZ - _topPlateThickness)
            vflip()
                boltHoleM3Tap(sideSize.x);
    }
}

module XY_Motor_Mount_Left_NEMA_14_stl() {
    NEMA_type = NEMA14_36;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left_NEMA_14")
        color(pp1_colour)
            XY_MotorMountCF(NEMA_type, left=true, basePlateThickness=basePlateThickness, height=42);
}

module XY_Motor_Mount_Right_NEMA_14_stl() {
    NEMA_type = NEMA14_36;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right_NEMA_14")
        color(pp1_colour)
            XY_MotorMountCF(NEMA_type, left=false, basePlateThickness=basePlateThickness, height=42);
}

module XY_Motor_Mount_Left_NEMA_17_stl() {
    NEMA_type = NEMA17_40;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left_NEMA_17")
        color(pp1_colour)
            XY_MotorMountCF(NEMA_type, left=true, basePlateThickness=basePlateThickness, height=42);
}

module XY_Motor_Mount_Right_NEMA_17_stl() {
    NEMA_type = NEMA17_40;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right_NEMA_17")
        color(pp1_colour)
            XY_MotorMountCF(NEMA_type, left=false, basePlateThickness=basePlateThickness, height=42);
}

//!1. Place the cork damper on the stepper motor and bolt the motor to the **XY_Motor_Mount_Left**.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Bolt the pulley to the motor shaft.
//
module XY_Motor_Mount_Left_CF_assembly()
assembly("XY_Motor_Mount_Left_CF", big=true, ngb=true) {

    NEMA_type = xyMotorType();

    stl_colour(pp1_colour)
        if (_xyMotorDescriptor == "NEMA14")
            XY_Motor_Mount_Left_NEMA_14_stl();
        else
            XY_Motor_Mount_Left_NEMA_17_stl();
    XY_Motor_Mount_CF_hardware(NEMA_type, left=true);
}

//!1. Place the cork damper on the stepper motor and bolt the motor to the **XY_Motor_Mount_Right**.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Bolt the pulley to the motor shaft.
//
module XY_Motor_Mount_Right_CF_assembly()
assembly("XY_Motor_Mount_Right_CF", big=true, ngb=true) {

    NEMA_type = xyMotorType();

    stl_colour(pp1_colour)
        if (_xyMotorDescriptor == "NEMA14")
            XY_Motor_Mount_Right_NEMA_14_stl();
        else
            XY_Motor_Mount_Right_NEMA_17_stl();
    XY_Motor_Mount_CF_hardware(NEMA_type, left=false);
}

module XY_Motor_Mount_CF_hardware(NEMA_type, left=true) {
    NEMA_width = NEMA_width(NEMA_type);
    coreXYPosBL = coreXYPosBL(NEMA_width);
    coreXYPosTR = coreXYPosTR(NEMA_width);
    separation = coreXYSeparation();
    coreXY_type = coreXY_type();
    //bearingType = coreXYBearing();
    washer = M3_washer;

    braceThickness = 5;
    braceOffsetZ = 2*bearingStackHeight() + yCarriageBraceThickness() + 0.5; // tolerance of 0.5

    height = 42;
    translate_z(eZ - _topPlateThickness - height + basePlateThickness) {
        translate(left ? [coreXYPosBL.x, coreXYPosTR.y] : [coreXYPosTR.x, coreXYPosTR.y]) {
            translate(left ? leftDrivePulleyOffset() : rightDrivePulleyOffset()) {     
                translate_z(-basePlateThickness)
                    rotate(left ? -90 : 90)
                        NEMA(NEMA_type, jst_connector=true);
                rotate(left ? 180 : 90)
                    NEMA_screw_positions(NEMA_type, 3)
                        boltM3Caphead(8);
                translate_z(left ? 15 : 5)
                    vflip(left)
                        pulley(coreXY_drive_pulley(coreXY_type));
            }
            /*screwLength = 25;
            translate_z(braceOffsetZ + braceThickness + eps)
                if ($preview && (is_undef($hide_bolts) || $hide_bolts == false))
                    explode(80, true)
                        boltM3Caphead(screwLength);
            bearingStack(bearingType)
                explode(25, true)
                    washer(washer)
                        explode(5, true)
                            washer(washer)
                                explode(5, true)
                                    bearingStack(bearingType);
            translate(left ? plainIdlerPulleyOffset() : -plainIdlerPulleyOffset()) {
                if (left) {
                    explode(5, true)
                        bearingStack(bearingType);
                    *explode(30)
                        translate_z(pulleyStackHeight)
                            stl_colour(pp3_colour)
                                XY_Motor_Mount_Pulley_Spacer_stl();
                } else {
                    *explode(5)
                        stl_colour(pp3_colour)
                            XY_Motor_Mount_Pulley_Spacer_stl();
                    translate_z(separation.z)
                        explode(10, true)
                            bearingStack(bearingType);
                }
                translate_z(braceOffsetZ + braceThickness + eps)
                    if ($preview && (is_undef($hide_bolts) || $hide_bolts == false))
                        explode(80, true)
                            boltM3Caphead(screwLength);
            }*/
        }
    }
}
