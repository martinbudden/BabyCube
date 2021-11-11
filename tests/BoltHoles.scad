//! Display the the boltholes, to check if they meet

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>

use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/LeftAndRightFaces.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/TopFace.scad>
use <../scad/printed/TopFaceAssemblies.scad>

include <../scad/utils/HolePositions.scad>

include <../scad/vitamins/bolts.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module BoltHole_test() {
    NEMA_type = _xyMotorDescriptor == "NEMA14" ? NEMA14 : NEMA17M;

    //baseLeftFeet();
    //baseRightFeet();
    BaseAL();
    //translate_z(eZ) color(pp3_colour) topFaceCover(NEMA_type);
    //translate_z(eZ + eps) color(pp3_colour) topFaceInterlock(NEMA_type);
    Top_Face_assembly();

    //Top_Face_assembly();
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
        Left_Face_stl();
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
                Right_Face_stl();
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
    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0])
            backFaceBaseHolePositions()
                 rotate([90, 0, 0])
                     translate_z(_basePlateThickness)
                        boltM3Caphead(10);

    Back_Face_assembly();
}

if ($preview) {
    let($hide_bolts=true)
    BoltHole_test();
}
