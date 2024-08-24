//! Display the left face

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/XY_Motors.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/SwitchShroud.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/FrontFace.scad>

include <../scad/utils/printParameters.scad>
include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>



NEMA_type = xyMotorType();

//$explode = 1;
//$pose = 1;

module Left_Face_test() {
    echoPrintSize();
    //CoreXYBelts(carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0]);

    //zipTieCutout();
    //Front_Face_CF_assembly();
    //Back_Face_CF_assembly();
    //translate([0, -eZ/2, 0]) 
    //Left_Face_stl();
    //Right_Face_stl();
    //leftFace(NEMA_type, useFrontSwitch=!true, fullyEnclosed=!true, fan=true);
    //rightFace(NEMA_type, useFrontSwitch=!true, fullyEnclosed=!true, fan=true);

    //Right_Face_CF_assembly();
    if (_useCNC) {
        Left_Face_CF_assembly();
    } else {
        //rotate([90, 0, 90]) Left_Face_stl();
        Left_Face_assembly(camera=!true);
        *rotate([90, 0, 90]) hflip()
            Switch_Shroud_stl();
    }
    //Back_Face_assembly();
    //translate([0, eY + 2*eSizeY, 0]) rotate([90, 0, 0]) Back_Face_CF();
    //Right_Face_assembly();
    //Right_Face_CF_assembly();
    //leftFace(NEMA_type);
    //translate([(eY + 2*eSizeY + _backPlateCFThickness)/2, eZ/2])
    //leftFaceCNC(NEMA_width(NEMA_type));
    //rightFaceCNC(NEMA_width(NEMA_type));
    //Left_Face();
    //Right_Face();
    //leftFaceSideCutouts(NEMA_width(NEMA_type), cnc=true);

    //Base_assembly();

    //webbingLeft(NEMA_type);
    //frame(NEMA_type, left=true);
    //idlerUpright(NEMA_width(NEMA_type), left=true);
    //let($preview=false)
    //faceCoreXYUpper(left=true);

    //translate([0, -40, 0])
    //XY_MotorUpright(NEMA_type, left=true, reversedBelts=_useReversedBelts);
    //yRailSupport(NEMA_type, left=true);


    *let($preview=false)
        translate_z(-eps) Back_Face_assembly();
    *translate([eX - eSizeX, 0, 0])
        rotate([0, -90, 0])
            Back_Face_stl();
    *rotate([90, 0, 180])
        Front_Lower_Chord_stl();
    *translate_z(eZ)
        rotate([90, 0, 180])
            Front_Upper_Chord_stl();
/*
    translate([0, eY + eSizeY, 0])
        rotate([90, 0, 0]) {
            backFaceBare();
            backFaceBrackets();
        }
*/
}

module Left_Face_CF_map() {
    translate([-1, 0, 0])
        rotate([0, 180, 0])
            Left_Face_CF(render=false);
    translate([0, 0, 3])
        Front_Face_CF(render=false);
    translate([-eY-23, 0, -3])
        rotate([0, 180, 0])
            Back_Face_CF(render=false);
}

module Left_Face_map() {
    translate([-eY - 2*eSizeY - 5, 0, 0])
        if (_useReversedBelts) {
            if (eZ == 200)
                Left_Face_y200_z200_stl();
            else
                Left_Face_y220_z210_stl();
        } else {
            Left_Face_stl();
        }

    if (eZ == 200)
        Back_Face_x220_z200_stl();
    else
        Back_Face_x220_z210_stl();

    translate([eY + 2*eSizeY + 5, 0, 0])
        translate([eX + 2*eSizeX, 0, 0])
            if (_useReversedBelts) {
                if (eZ == 200)
                    Right_Face_y200_z200_stl();
                else
                    Right_Face_y220_z210_stl();
            } else {
                Right_Face_stl();
            }
}

*if (_useCNC)
    Left_Face_CF_map();
else
    Left_Face_map();

if ($preview)
    Left_Face_test();
else
    scale([0.5, 0.5, 0.5]) Left_Face_y220_z210_stl();
