//! Display the top face

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/TopFace.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/X_CarriageAssemblies.scad>
use <../scad/printed/XY_MotorMount.scad>

use <../scad/utils/carriageTypes.scad>
use <../scad/utils/CoreXYBelts.scad>
use <../scad/utils/cutouts.scad>
use <../scad/utils/printParameters.scad>
use <../scad/utils/X_Rail.scad>

use <../scad/vitamins/bolts.scad>

use <../scad/MainAssemblies.scad>

include <../scad/Parameters_Main.scad>


NEMA_type = xyNEMA_type();

//$explode = 1;
//$pose = 1;
module Top_Face_test() {
    echoPrintSize();

    //xRailCarriagePosition() Print_head_assembly();
    //fullPrinthead();
    //CoreXYBelts(NEMA_width(NEMA_type), carriagePosition, x_gap=16, show_pulleys=false);
    //Top_Face_stl();
    //Top_Face();
    //rotate(-90) topFaceSideDogbones();
    //translate([0, -eX, 0]) sideFaceTopDogbones();
    //topFaceSideCutouts();
    //topFaceBackCutouts();
    *translate_z(eZ)
        topFaceCover(NEMA_type);
    *translate_z(eZ + eps)
        topFaceInterlock(NEMA_type);

    //Top_Face_Stage_1_assembly();
    //Top_Face_Stage_2_assembly();
    if (_variant == "BC200CF")
        Top_Face_CF_assembly();
    else
        Top_Face_assembly();
    //Top_Face_NEMA_17_Stage_1_assembly()
    //Top_Face_NEMA_17_Stage_2_assembly();
    //Top_Face_NEMA_17_assembly();
    //printheadWiring();
    //CoreXYBelts(_xyNEMA_width, carriagePosition, x_gap=16, show_pulleys=false);

    //Left_Face_assembly();
    //Right_Face_assembly();

    //Back_Face_Stage_1_assembly();
    //Back_Face_assembly();
    //Back_Face();

    *translate([0, -eps, eZ])
        rotate([90, 0, 180]) {
            Front_Upper_Chord_stl();
            //color(grey(20)) frontUpperChordMessage();
        }

}

//if ($preview)
    Top_Face_test();
/*else
    vflip()
        scale([0.5, 0.5, 0.5])
            Top_Face_stl();*/
