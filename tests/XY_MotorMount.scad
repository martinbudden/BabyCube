//! Display the XY motor mounts

include <../scad/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../scad/printed/XY_Motors.scad>
include <../scad/printed/XY_MotorMountCF.scad>

include <../scad/Parameters_Main.scad>



//$explode = 1;
//$pose = 1;
module XY_MotorMount_test() {
    NEMA_type = xyMotorType();
    NEMA_width = NEMA_width(NEMA_type);
    echo(XY_MotorMountSize=XY_MotorMountSize(NEMA_width));
    echo(coreXY_drive_pulley_x_alignment=coreXY_drive_pulley_x_alignment(coreXY_type()));
    echo(leftDrivePulleyOffset=leftDrivePulleyOffset());
    echo(rightDrivePulleyOffset=rightDrivePulleyOffset());

    //XY_MotorUpright(NEMA_type, left);
    //XY_MotorMount(NEMA_type, left, basePlateThickness = 5, offset = basePlateThickness + eZ-coreXYPosBL(NEMA_width(NEMA_type)).z+(left?0:coreXYSeparation().z));
    //XY_MotorMountHardware(NEMA_type);
    rotate([90, 0, 90])
        XY_MotorPosition(NEMA_width, left=true) {
            if (_xyMotorDescriptor == "NEMA14")
                XY_Motor_Mount_Left_stl();
            else
                XY_Motor_Mount_Left_NEMA_17_stl();
        }
    translate([eX + 2 * eSizeX - NEMA_width - _sidePlateThickness - 1, 0, 0])
        rotate([90, 0, 90])
            XY_MotorPosition(NEMA_width, left=false)
                rotate(180) {
                    if (_xyMotorDescriptor == "NEMA14")
                        XY_Motor_Mount_Right_stl();
                    else
                        XY_Motor_Mount_Right_NEMA_17_stl();
                }
    topFaceMotors(NEMA_type);
}

module topFaceMotors(NEMA_type) {
    NEMA_width = NEMA_width(NEMA_type);
    translate([0, 0, -13]) {
        translate(coreXYPosTR(NEMA_width) + [rightDrivePulleyOffset().x, rightDrivePulleyOffset().y, 0]) {
            rotate(90)
                NEMA(NEMA_type, jst_connector=true);
            translate_z(8)
                #pulley(GT2x20ob_pulley);
        }
        translate([coreXYPosBL(NEMA_width).x, coreXYPosTR(_xyNEMA_width).y, coreXYPosTR(_xyNEMA_width).z] + [leftDrivePulleyOffset().x, leftDrivePulleyOffset().y, 0]) {
            rotate(-90)
                NEMA(NEMA_type, jst_connector=true);
            translate_z(18)
                vflip()
                    #pulley(GT2x20ob_pulley);
        }
    }
}


if ($preview)
    if (_useCNC)
        XY_MotorMount_test();
