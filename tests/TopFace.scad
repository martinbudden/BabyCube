//! Display the top face

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/Extras.scad>
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

use <../scad/MainAssembly.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Top_Face_test() {
    echoPrintSize();

    //xRailCarriagePosition(carriagePosition()) Printhead_assembly();
    //fullPrinthead();
    //CoreXYBelts(carriagePosition());
    //Top_Face_stl();
    //Top_Face();
    //rotate(-90) topFaceSideDogbones();
    //translate([0, -eX, 0]) sideFaceTopDogbones();
    //topFaceSideCutouts();
    //topFaceBackCutouts();
    *translate_z(eZ)
        topFaceCover(xyMotorType());
    *translate_z(eZ + eps)
        topFaceInterlock(xyMotorType());

    //let($hide_bolts=true)
    if (_xyMotorDescriptor == "NEMA14") {
        if (_useCNC)
            Top_Face_CF_assembly();
        else
            Top_Face_assembly();
        //Top_Face_Stage_1_assembly();
        //Top_Face_Stage_2_assembly();
    } else {
        Top_Face_NEMA_17_assembly();
        //Top_Face_NEMA_17_Stage_1_assembly()
        //Top_Face_NEMA_17_Stage_2_assembly();
    }
    //printheadWiring();
    //CoreXYBelts(carriagePosition());

    //Left_Face_assembly();
    //Right_Face_assembly();
    //bowdenTube();

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
