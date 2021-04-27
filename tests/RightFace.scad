//! Display the right face

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/Extras.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/SpoolHolder.scad>
use <../scad/printed/XY_MotorMount.scad>

use <../scad/utils/printParameters.scad>
use <../scad/utils/CoreXYBelts.scad>

use <../scad/vitamins/bolts.scad>

use <../scad/Parameters_CoreXY.scad>
include <../scad/Parameters_Main.scad>


NEMA_type = xyNEMA_type();
NEMA_width = NEMA_width(NEMA_type);

//$explode = 1;
//$pose = 1;
module Right_Face_test() {
    echoPrintSize();
    echoPrintParameters();
    //CoreXYBelts(NEMA_width(NEMA_type), carriagePosition, x_gap=16, show_pulleys=false);

    Right_Face_assembly();
    faceRightSpoolHolder();
    faceRightSpool();
    bowdenTube();
    //Right_Face_CF_assembly();
    //Right_Face_stl();
    //Right_Face_NEMA_17_stl();

    //Right_Face_Stage_1_assembly();
    //Left_Face_assembly();

    //webbingRight(NEMA_type);
    //frame(NEMA_type, left=false);
    //XY_MotorUpright(NEMA_type, left=false);
    //bowdenTube();
    //hotEndWiring();

    //Back_Face();
    *translate([-eY-eSizeY, 0, eX+2*eSizeX])
        rotate([0, 90, 0])
            Back_Face_stl();
}

//if ($preview)
    Right_Face_test();
