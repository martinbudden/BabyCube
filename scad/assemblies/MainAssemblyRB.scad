include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

use <../printed/BackFace.scad>
use <../printed/BackFaceAssemblies.scad>
use <../printed/Base.scad>
use <../printed/SpoolHolderExtras.scad>
use <../printed/PrintheadExtras.scad>
use <../printed/FrontChords.scad>
use <../printed/LeftAndRightFaceAssemblies.scad>
use <../printed/PrintheadAssemblies.scad>
use <../printed/PrintheadAssembliesDropEffectXG.scad>
use <../printed/PrintheadAssembliesE3DRevo.scad>
use <../printed/TopFaceAssemblies.scad>
use <../printed/X_CarriageAssemblies.scad>

include <../utils/HolePositions.scad>
include <../utils/StagedAssemblyMain.scad>

include <../config/Parameters_CoreXY.scad>
include <../utils/CoreXYBelts.scad>

use <../config/Parameters_Positions.scad>

hotendDescriptor = "DropEffectXG";


//!1. Bolt the **Right_Face** and the right feet to the base.
//
module Stage_1_RB_assembly()
main_staged_assembly("Stage_1_RB", big=true, ngb=true) {

    assert(holePositionsYRailShiftX==yRailShiftX());

    translate_z(-eps)
        Base_assembly();

    explode([100, 50, 0], show_line=false)
        Right_Face_assembly();
    translate_z(-eps) {
        stl_colour(pp2_colour)
            baseFeet(left=false);
        baseFeet(left=false, hardware=true);
    }
    baseRightHolePositions(-_basePlateThickness)
        vflip()
            explode(40)
                boltM3Buttonhead(8);
}

//! Add the **Back_Face** and bolt it to the right face and the base.
//
module Stage_2_RB_assembly() pose(a=[55+10, 0, 25 + 80])
main_staged_assembly("Stage_2_RB", big=true, ngb=true) {

    Stage_1_RB_assembly();

    explode([0, 200, 0], true) {
        Back_Face_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                //Back_Face_210_stl();
                backFaceHolePositions(left=false, z=-_backPlateThickness, cf=true)
                    vflip()
                        explode(50)
                            boltM3Countersunk(6);
                backFaceRightBracketHolePositions(-_backPlateThickness, reversedBelts=true)
                    vflip()
                        explode(50)
                            boltM3Countersunk(10);
            }
       rotate([90, 0, 0])
            xyMotorMountBackHolePositions(left=false, z= -eY - 2*eSizeY - _backPlateCFThickness) // bolt back face to right face motor mounts
                vflip()
                    explode(50, true)
                        boltM3Countersunk(10);
    }
    baseBackHolePositions(-_basePlateThickness) // bolt back face to base
        vflip()
            explode(50, true)
                boltM3Buttonhead(10);
    if (!exploded())
        backFaceCableTies();
}


//! Add the **Top_Face**.
//
module Stage_3_RB_assembly()
main_staged_assembly("Stage_3_RB", big=true, ngb=true) {

    Stage_2_RB_assembly();

    explode(50, true, show_line=false)
        if (_xyMotorDescriptor == "NEMA14")
            Top_Face_assembly();
        else
            Top_Face_NEMA_17_assembly();

    topFaceBackHolePositions(eZ + _topPlateCoverThickness)
        explode(50, true)
            boltM3Buttonhead(12);
    topFaceRightSideHolePositions(eZ + _topPlateCoverThickness)
        explode(50, true)
            boltM3Buttonhead(12);
    xyMotorMountTopHolePositions(left=false, z=eZ + _topPlateCoverThickness)
        explode(70, true)
            boltM3Buttonhead(12);
}

//!1. Bolt the **Left_Face** and the left feet to the base.
//!2. Bolt the **Left_Face** to the back face and the top face.
//
module Stage_4_RB_assembly()
main_staged_assembly("Stage_4_RB", big=true, ngb=true) {

    Stage_3_RB_assembly();

    explode([-300, 0, 25])
        Left_Face_RB_assembly();

    explode([-200, 0, 50], true, show_line=false)
        baseCoverAssembly(cf=false);

    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0]) {
            backFaceLeftBracketHolePositions(-_backPlateThickness, reversedBelts=true) // bolt back face to left face
                vflip()
                    explode(50)
                        boltM3Countersunk(10);
            backFaceHolePositions(left=true, z=-_backPlateThickness, cf=true)
                vflip()
                    explode(50)
                        boltM3Countersunk(6);
        }

    xyMotorMountTopHolePositions(left=true, z=eZ + _topPlateCoverThickness)
        explode(20, true)
            boltM3Buttonhead(12);
    rotate([90, 0, 0])
        xyMotorMountBackHolePositions(left=true, z= -eY - 2*eSizeY - _backPlateCFThickness) // bolt back face to motor mounts
            vflip()
                explode(50, true)
                    boltM3Countersunk(10);
    translate_z(-eps) {
        stl_colour(pp2_colour)
            baseFeet(left=true);
        baseFeet(left=true, hardware=true);
    }
    topFaceLeftSideHolePositions(eZ + _topPlateCoverThickness)
        boltM3Buttonhead(12);
    baseLeftHolePositions(-_basePlateThickness)
        vflip()
            explode(80)
                boltM3Buttonhead(8);
}


//!1. Add the **X_Carriage_Belt_Side_MGN9C_RB** assembly
//!2. Thread the belts in the pattern shown.
//!4. Clamp the belts using the **XX_Carriage_Belt_Clamp**
//!3. Adjust the belt tension.
//
module Stage_5_RB_assembly()
main_staged_assembly("Stage_5_RB", big=true, ngb=true) {

    Stage_4_RB_assembly();

    explode([0, -75, 150], show_line=false)
        not_on_bom()
            CoreXYBelts(carriagePosition() + [25, 0]);
    explode([0, -75, 150], true, show_line=false)
        printheadBeltSide(halfCarriage=false, reversedBelts=true);
}

//!1. Attach the **Printhead Assembly** to the X_Carriage
//
module Stage_6_RB_assembly()
main_staged_assembly("Stage_6_RB", big=true, ngb=true) {

    Stage_5_RB_assembly();

    if (!exploded())
        printheadWiring(hotendDescriptor, carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0], backFaceZipTiePositions());
    explode(100, true)
        if (hotendDescriptor == "E3DRevo")
            printheadHotendSideE3DRevo();
        else if (hotendDescriptor == "DropEffectXG")
            printheadHotendSideDropEffectXG();
}

module RB_FinalAssembly(test=false) {
    assert(_useReversedBelts==true || test==true);
    assert(_useCNC==false || test==true);
    assert(holePositionsYRailShiftX==yRailShiftX());

    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        Stage_6_RB_assembly();

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

        explode(150)
            bowdenTube(hotendDescriptor, carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0], extruderPosition(_xyNEMA_width));

        explode([75, 0, 100])
            faceRightSpoolHolder();
        explode([150, 0, 0])
            faceRightSpool();
    }
}
