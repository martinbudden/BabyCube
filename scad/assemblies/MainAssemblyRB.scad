include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

use <../printed/BackFace.scad>
use <../printed/BackFaceAssemblies.scad>
use <../printed/Base.scad>
include <../printed/Extras.scad>
use <../printed/FrontChords.scad>
use <../printed/LeftAndRightFaceAssemblies.scad>
use <../printed/PrintheadAssemblies.scad>
use <../printed/PrintheadAssembliesE3DRevo.scad>
use <../printed/TopFaceAssemblies.scad>
use <../printed/X_CarriageAssemblies.scad>

include <../utils/HolePositions.scad>
include <../utils/StagedAssembly.scad>

include <../config/Parameters_CoreXY.scad>
include <../utils/CoreXYBelts.scad>

use <../config/Parameters_Positions.scad>


staged_assembly = true; // set this to false for faster builds during development

//!1. Bolt the **Right_Face** and the right feet to the base.
//
module Stage_1_assembly()
staged_assembly("Stage_1", big=true, ngb=true) {

    assert(holePositionsYRailShiftX==yRailShiftX());

    translate_z(-eps)
        Base_assembly();

    explode([100, 50, 0])
        Right_Face_assembly();
    translate_z(-eps) {
        stl_colour(pp2_colour)
            baseFeet(left=false);
        baseFeet(left=false, hardware=true);
    }
    explode(-40)
        baseRightHolePositions(-_basePlateThickness)
            vflip()
                boltM3Buttonhead(8);
}

//! Add the **Back_Face** and bolt it to the right face and the base.
//
module Stage_2_assembly() pose(a=[55+10, 0, 25 + 80])
staged_assembly("Stage_2", big=true, ngb=true) {

    Stage_1_assembly();

    explode([0, 200, 0], true) {
        Back_Face_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                backFaceHolePositions(left=false, z=-_backPlateThickness, cf=false)
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


//! Add the **Top_Face**.
//
module Stage_3_assembly()
staged_assembly("Stage_3", big=true, ngb=true) {

    Stage_2_assembly();

    explode(50, true) {
        if (_xyMotorDescriptor == "NEMA14")
            Top_Face_assembly();
        else
            Top_Face_NEMA_17_assembly();

        topFaceBackHolePositions(eZ + _topPlateCoverThickness)
            boltM3Buttonhead(12);
        topFaceRightSideHolePositions(eZ + _topPlateCoverThickness)
            boltM3Buttonhead(12);
        xyMotorMountTopHolePositions(left=false, z=eZ + _topPlateCoverThickness)
            explode(20, true)
                boltM3Buttonhead(8);
    }
}

//!1. Bolt the **Left_Face** and the left feet to the base.
//!2. Bolt the **Left_Face** to the back fase and the top face.
module Stage_4_assembly()
staged_assembly("Stage_4", big=true, ngb=true) {

    Stage_3_assembly();

    explode([-250, 0, 50], true, show_line=false)
        baseCoverAssembly();

    explode([-300, 0, 25]) {
        Left_Face_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0])
                backFaceHolePositions(left=true, z=-_backPlateThickness, cf=false)
                    vflip()
                        explode(50)
                            boltM3Countersunk(6);
        xyMotorMountTopHolePositions(left=true, z=eZ + _topPlateCoverThickness)
            explode(20, true)
                boltM3Buttonhead(8);
    }

    translate_z(-eps) {
        stl_colour(pp2_colour)
            baseFeet(left=true);
        baseFeet(left=true, hardware=true);
    }
    topFaceLeftSideHolePositions(eZ + _topPlateCoverThickness)
        boltM3Buttonhead(12);
    explode(-80)
        baseLeftHolePositions(-_basePlateThickness)
            vflip()
                boltM3Buttonhead(8);
}


//!1. Add the Printhead.
//!2. Thread the belts in the pattern shown.
//!3. Adjust the belts tension.
//
module Stage_5_assembly()
staged_assembly("Stage_5", big=true, ngb=true) {

    Stage_4_assembly();

    explode(100)
        CoreXYBelts(carriagePosition());
    explode(100, true) {
        printheadBeltSide(halfCarriage=_useHalfCarriage);
    }
}

//!Bolt the BabyCube nameplate and the **Front_Lower_Chord** to the front of the frame.
//
module Stage_6_assembly()
staged_assembly("Stage_6", big=true, ngb=true) {

    Stage_5_assembly();

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
        rotate([90, 0, 180])
            color(pp2_colour)
                Front_Lower_Chord_Solid_stl();
        frontLowerChordHardware();
    }
    topFaceFrontHolePositions(eZ + _topPlateCoverThickness, useJoiner=false)
        boltM3Buttonhead(12);

    baseFrontHolePositions(-_basePlateThickness)
        vflip()
            explode(30)
                boltM3Buttonhead(10);
}

module FinalAssembly() {
    hotendDescriptor = "E3DRevo";
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        Stage_6_assembly();

        if (!exploded())
            printheadWiring(carriagePosition(), hotendDescriptor);
        explode(100, true)
            if (hotendDescriptor == "E3DRevo")
                printheadHotendSideE3DRevo();
        explode(150)
            bowdenTube(carriagePosition(), hotendDescriptor);
        explode([75, 0, 100])
            faceRightSpoolHolder();
        explode([150, 0, 0])
            faceRightSpool();
    }
}
