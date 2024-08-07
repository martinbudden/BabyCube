//! Display the right face

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/Base.scad>
include <../scad/printed/SpoolHolderExtras.scad>
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
    //carriagePosition = carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0];
    //CoreXYBelts(carriagePosition);
    //translate_z(4) Right_Face_CF();
    //rotate([0, 180, 0]) rightFace(NEMA14T(), fullyEnclosed=true, fan=true);
    Right_Face_stl();

    if (_useCNC) {
        Right_Face_CF_assembly();
        //baseCoverAssembly(cf=true);
    } else {
        //translate([eX + 2 * eSizeX + eps, 0, 0]) rotate([90, 0, -90]) rightFace(NEMA14T(), fullyEnclosed=!true, fan=true);
        Right_Face_assembly();
        //IEC_Housing();
        //baseCoverAssembly(cf=false);
    }
    //faceRightSpoolHolder(cf=_useCNC);
    //faceRightSpool(cf=_useCNC);
    //echo(ep=extruderPosition(_xyNEMA_width));
    //bowdenTube(carriagePosition, "E3DRevo");
    //Right_Face_NEMA_17_stl();

    //Right_Face_Stage_1_assembly();
    //Left_Face_assembly();

    //webbingRight(xyMotorType());
    //frame(NEMA_type, left=false);
    //XY_MotorUpright(xyMotorType(), left=false, reversedBelts=_useReversedBelts);
    //hotEndWiring();

    //Base_assembly();
    //Back_Face();
    *translate([-eY-eSizeY, 0, eX + 2*eSizeX])
        rotate([0, 90, 0])
            Back_Face_stl();
}

if ($preview)
    Right_Face_test();
