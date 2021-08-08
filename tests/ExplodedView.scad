//! Display an exploded view of the BabyCube

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/DisplayHousingAssemblies.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/TopFaceAssemblies.scad>

include <../scad/Parameters_Main.scad>


$explode = 1;
module Exploded_View_test() {
    explode = 150;

    no_explode()
        Base_assembly();
    explode([0, explode, 0]) {
        Back_Face_assembly();
        backFaceCableTies();
        }
    explode([-explode, 0, 0])
        Left_Face_assembly();
    explode([explode, 0, 0])
        Right_Face_assembly();
    explode([0, 0, 1.25*explode]) {
        Top_Face_assembly();
        //fullPrinthead();
        printheadHotendSide(explode=100);
        printheadBeltSide(explode=100);
    }
    explode([0, -explode, 0]) {
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
}

if ($preview)
    rotate(-90 + 30)
        translate([-eX/2, -eY/2, 0])
            Exploded_View_test();
