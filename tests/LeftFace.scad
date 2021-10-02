//! Display the left face

include <../scad/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/XY_MotorMount.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/SwitchShroud.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/FrontChords.scad>

use <../scad/utils/CoreXYBelts.scad>
include <../scad/utils/printParameters.scad>

include <../scad/Parameters_Main.scad>


NEMA_type = xyMotorType();

//$explode = 1;
//$pose = 1;
module Left_Face_test() {
    echoPrintSize();
    //CoreXYBelts(carriagePosition());

    //zipTieCutout();
    if (_useCNC)
        Left_Face_CF_assembly();
    else
        Left_Face_assembly(camera=!true);
    *rotate([90, 0, 90]) hflip()
        Switch_Shroud_stl();
    //Right_Face_assembly();
    //Right_Face_CF_assembly();
    //Back_Face_assembly();
    *rotate([90, 0, 90])
        Left_Face_stl();
    //leftFace(NEMA_type);
    //translate([(eY + 2*eSizeY + _backPlateCFThickness)/2, eZ/2])
    //leftFaceCF(NEMA_width(NEMA_type));
    //rightFaceCF(NEMA_width(NEMA_type));
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
    //XY_MotorUpright(NEMA_type, left=true);
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

if ($preview)
    Left_Face_test();
else
    scale([0.5, 0.5, 0.5]) Left_Face_stl();
