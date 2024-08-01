//! Display the right face

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/Base.scad>
include <../scad/printed/Extras.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
include <../scad/printed/SpoolHolder.scad>
use <../scad/printed/XY_Motors.scad>

include <../scad/utils/printParameters.scad>

include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>


//$explode = 1;
//$pose = 1;
module Right_Face_test() {
    //echoPrintSize();
    //CoreXYBelts(carriagePosition(), x_gap=16);
    //Right_Face_CF();

    if (_useCNC) {
        Right_Face_CF_assembly();
    } else {
        //translate([eX + 2 * eSizeX + eps, 0, 0]) rotate([90, 0, -90]) Right_Face_stl();
        Right_Face_assembly();
        //IEC_Housing();
    }
    //faceRightSpoolHolder(cf=_useCNC);
    //faceRightSpool(cf=_useCNC);
    //echo(ep=extruderPosition(_xyNEMA_width));
    //bowdenTube(carriagePosition(), "E3DRevo");
    //Right_Face_NEMA_17_stl();

    //Right_Face_Stage_1_assembly();
    //Left_Face_assembly();

    //webbingRight(xyMotorType());
    //frame(NEMA_type, left=false);
    //XY_MotorUpright(xyMotorType(), left=false);
    //hotEndWiring();

    //Base_assembly();
    //Back_Face();
    *translate([-eY-eSizeY, 0, eX + 2*eSizeX])
        rotate([0, 90, 0])
            Back_Face_stl();
}

if ($preview)
    Right_Face_test();
