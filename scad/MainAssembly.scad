include <global_defs.scad>

include <NopSCADlib/core.scad>

use <printed/BackFace.scad>
use <printed/BackFaceAssemblies.scad>
use <printed/Base.scad>
use <printed/DisplayHousingAssemblies.scad>
use <printed/Extras.scad>
use <printed/FrontChords.scad>
use <printed/LeftAndRightFaceAssemblies.scad>
use <printed/PrintheadAssemblies.scad>
use <printed/TopFaceAssemblies.scad>
use <printed/X_CarriageAssemblies.scad>

use <utils/carriageTypes.scad>
use <utils/CoreXYBelts.scad>
use <utils/HolePositions.scad>

use <vitamins/bolts.scad>

use <Parameters_Positions.scad>
include <Parameters_Main.scad>


staged_assembly = true; // set this to false for faster builds during development

module staged_assembly(name, big, ngb) {
    if (staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}

//! Bolt the Left_Face and the left feet to the base.
//
module Stage_1_assembly()
staged_assembly("Stage_1", big=true, ngb=true) {

    explode([-100, 0, 25])
        Left_Face_assembly();

    translate_z(-eps)
        Base_assembly();

    explode(-20, true)
        translate_z(-eps) {
            stl_colour(pp2_colour)
                baseLeftFeet();
            baseLeftFeet(hardware=true);
        }
    explode(-40)
        baseLeftHolePositions(-_basePlateThickness)
            vflip()
                boltM3Buttonhead(8);
}

//! Bolt the Right_Face and the right feet to the base.
//
module Stage_2_assembly()
staged_assembly("Stage_2", big=true, ngb=true) {

    Stage_1_assembly();

    explode([100, 50, 0])
        Right_Face_assembly();

    explode(-20, true)
        translate_z(-eps) {
            stl_colour(pp2_colour)
                baseRightFeet();
            baseRightFeet(hardware=true);
        }
    explode(-40)
        baseRightHolePositions(-_basePlateThickness)
            vflip()
                boltM3Buttonhead(8);
}

//! Add the Back_Face and bolt it to the left and right faces and the base.
//
module Stage_3_assembly()
staged_assembly("Stage_3", big=true, ngb=true) {

    Stage_2_assembly();

    explode([0, 200, 0], true) {
        Back_Face_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                backFaceAllHolePositions(-_backPlateThickness)
                    vflip()
                        explode(50)
                            boltM3Countersunk(6);
                backFaceBracketHolePositions(-_backPlateThickness)
                    vflip()
                        explode(50)
                            boltM3Countersunk(10);
            }
            baseBackHolePositions(-_basePlateThickness)
                vflip()
                    boltM3Buttonhead(10);
    }
    if (!exploded())
        backFaceCableTies();
}


//!Bolt the BabyCube nameplate and the Display_Housing to the front of the frame.
//
module Stage_4_assembly()
staged_assembly("Stage_4", big=true, ngb=true) {

    Stage_3_assembly();

    explode([0, -20, 0], true) {
        translate_z(eZ)
            rotate([90, 0, 180]) {
                translate([0, -eps, 0]) {
                    stl_colour(pp2_colour)
                        Front_Upper_Chord_stl();
                    Front_Upper_Chord_hardware();
                }
                color(pp4_colour)
                    frontUpperChordMessage();
            }
        Display_Housing_assembly();
        frontLowerChordHardware();
    }
    baseFrontHolePositions(-_basePlateThickness)
        vflip()
            explode(30)
                boltM3Buttonhead(10);
}

//! Add the Top_Face.
//
module Stage_5_assembly()
staged_assembly("Stage_5", big=true, ngb=true) {

    Stage_4_assembly();

    explode(50, true) {
        Top_Face_assembly();
        topFaceAllHolePositions(eZ + _topPlateCoverThickness)
            boltM3Buttonhead(12);
    }
}

//!1. Add the Printhead.
//!2. Thread the belts in the pattern shown.
//!3. Adjust the belts tension.
//
module Stage_6_assembly()
staged_assembly("Stage_6", big=true, ngb=true) {

    Stage_5_assembly();

    explode(100)
        CoreXYBelts(carriagePosition());
    explode(100, true)
        fullPrinthead();
    if (!exploded())
        printheadWiring();
}

module FinalAssembly() {
    if ($target == "BC200_test") {
        Left_Face_stl();
        Right_Face_stl();
    } else {
        Stage_6_assembly();

        bowdenTube();
        faceRightSpoolHolder();
        faceRightSpool();
    }
}
