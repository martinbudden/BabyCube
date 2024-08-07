//! Display the the boltholes, to check if they meet

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>

use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/TopFaceAssemblies.scad>

include <../scad/utils/HolePositions.scad>

include <../scad/vitamins/bolts.scad>

include <../scad/config/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module BoltHole_test() {
    NEMA_type = _xyMotorDescriptor == "NEMA14" ? NEMA14_36 : NEMA17_40;

    //baseFeet(left=true);
    //baseFeet(left=false);
    BaseAL();

    //Top_Face_assembly();
    //translate_z(eZ) color(pp3_colour) topFaceCover(NEMA_type);
    //translate_z(eZ + eps) color(pp3_colour) topFaceInterlock(NEMA_type);
    translate_z(eZ + eps) color(pp3_colour) topFace(NEMA14_36, useReversedBelts=_useReversedBelts);


    // front connector
    translate([0, -eps, eps])
        rotate([90, 0, 180])
            Front_Lower_Chord_Solid_stl();
    translate([0, -eps, eZ])
        rotate([90, 0, 180])
            Front_Upper_Chord_stl();

    // left face
    translate([-eps, 0, 0])
    rotate([90, 0, 90]) {
        if (!_useReversedBelts)
            Left_Face_stl();
        else if (eZ==200)
            Left_Face_y200_z200_stl();
        else
            Left_Face_y220_z210_stl();
        lowerChordHolePositions()
            rotate([90, 0, 0])
                boltM3Buttonhead(10);
        faceConnectorHolePositions()
            rotate([90, 0, 0])
                boltM3Caphead(10);
    }

    // right face
    translate([eX + 2*eSizeX + eps, 0, 0])
        rotate([90, 0, 90])
            hflip()
                if (!_useReversedBelts)
                    Right_Face_stl();
                else if (eZ==200)
                    Right_Face_y200_z200_stl();
                else
                    Right_Face_y220_z210_stl();
    translate([eX + 2*eSizeX, 0, 0])
        rotate([90, 0, 90])
            mirror([0, 0, 1]) {
                lowerChordHolePositions()
                    rotate([90, 0, 0])
                        boltM3Buttonhead(10);
                faceConnectorHolePositions()
                    rotate([90, 0, 0])
                        boltM3Caphead(10);
            }

    // back face
    //Back_Face_assembly();
    translate([0, eY + 2*eSizeY + eps, 0])
        rotate([90, 0, 0])
            stl_colour(pp2_colour)
                if (eZ==200)
                    Back_Face_x220_z200_stl();
                else if (eZ == 210)
                    Back_Face_x220_z210_stl();

}

module BoltHole_CF_test() {
    Back_Face_Top_Joiner_stl();
    rotate([90, 0, 90])
        Back_Face_Left_Joiner_stl();
    translate([eX + 2*eSizeX + eps, 0, 0])
        rotate([-90, 0, 90])
            Back_Face_Right_Joiner_stl();

    Base_Front_Joiner_stl();
    rotate([90, 0, 90])
        Base_Left_Joiner_stl();
    translate([eX + 2*eSizeX, 0, 0])
        rotate([-90, 0, 90])
            Base_Right_Joiner_stl();

    Top_Face_Front_Joiner_stl();
    rotate([90, 0, 90])
        Top_Face_Left_Joiner_stl();
    translate([eX + 2*eSizeX + eps, 0, 0])
        rotate([-90, 0, 90])
            Top_Face_Right_Joiner_stl();

    BaseAL();

    translate([0, eY + 2*eSizeY + eps, 0])
        rotate([90, 0, 0]) {
            Back_Face_CF();
            translate([eX/2 + eSizeX, 0, _zLeadScrewOffset])
                rotate([90, -90, 0])
                    stl_colour(pp2_colour)
                        Z_Motor_Mount_stl();
        }

    rotate([90, 0, 90])
      Left_Face_CF();

    translate([eX + 2*eSizeX + eps, 0, 0])
        rotate([90, 0, 90])
            Right_Face_CF();

    translate_z(eZ - _topPlateThickness + eps)
        Top_Face_CF();

    rotate([90, 0, 0])
        Front_Face_CF();
}


if ($preview)
    if (_useCNC)
        BoltHole_CF_test();
    else
        BoltHole_test();

