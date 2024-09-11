//! Display an exploded view of the BabyCube

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/Base.scad>
use <../scad/printed/DisplayHousingAssemblies.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/PrintheadAssembliesAll.scad>
use <../scad/printed/TopFaceAssemblies.scad>

include <../scad/config/Parameters_Main.scad>


$explode = 1;
module Exploded_View_test(full=true) {
    explode = 150;

    if (full)
        translate_z(-explode)
            no_explode()
                Base_assembly();
    explode([0, explode, 0], show_line=false) {
        Back_Face_assembly();
        if (full)
            backFaceCableTies();
        }
    explode([-explode, 0, 0], show_line=false)
        Left_Face_assembly();
    explode([explode, 0, 0], show_line=false)
        Right_Face_assembly();
    explode([0, 0, 1.25*explode], show_line=false) {
        if (full) {
            Top_Face_assembly();
            printheadHotendSide("DropEffectXG", explode=100);
            printheadBeltSide(explode=100, reversedBelts=_useReversedBelts);
        } else {
            Top_Face_Stage_1_assembly();
        }
    }
    if (full)
        explode([0, -explode, 0], show_line=false) {
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
                if (_useFrontDisplay)
                    Display_Housing_assembly();
                else
                    rotate([90, 0, 180])
                        Front_Lower_Chord_Solid_stl();
                frontLowerChordHardware();
        }
}

module Exploded_View_CF_test(full=false) {
    explode = 100;

    no_explode()
        Base_CF_assembly();
    explode([0, 1.25*explode, 0], show_line=false)
        Back_Face_CF_assembly();
    explode([-explode, 0, 0], show_line=true)
        rotate([90, 0, 90])
            Left_Face_CF();
    explode([explode, 0, 0], show_line=false)
        Right_Face_CF_assembly();
    explode([0, 0, 2*explode], show_line=false) {
        Top_Face_CF_assembly();
        printheadHotendSide("DropEffectXG", explode=100);
    }
    if (full) {
        explode([0, -explode, 0], show_line=true)
            Front_Face_CF_assembly();
    } else {
        explode([0, -2*explode, 0], show_line=false)
            rotate([90, 0, 0])
                Front_Face_CF();
    }
}

// camera=0,0,0,70,0,315,500 for tests
// camera=0,0,0,55,0,25,140 for views
if ($preview)
    rotate([10, 0, -70])
        translate([-eX/2, -eY/2, 0])
            if (_useCNC)
                Exploded_View_CF_test(full=true);
            else
                Exploded_View_test();
