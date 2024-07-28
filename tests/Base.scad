//! Display the base

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/fans.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/DisplayHousingAssemblies.scad>
use <../scad/printed/BackFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>
use <../scad/printed/FrontFace.scad>
use <../scad/printed/FrontChords.scad>
use <../scad/printed/Printbed.scad>
use <../scad/printed/Printbed3point.scad>

include <../scad/vitamins/pcbs.scad>

include <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Base_test() {
    //PSU();
    //BaseAL_dxf();
    //BaseAL(BTT_SKR_MINI_E3_V2_0);
    //BaseAL();
    //Base_stl();
    //Base_template_stl();
    //let($hide_pcb=true)
    //Base_CF_Stage_1_assembly();
    //#baseCoverAssembly();
    //Base_Cover_stl();
    if (_useCNC)
        Base_CF_assembly();
    else
        Base_assembly();
    //baseAssembly(BTT_SKR_MINI_E3_V2_0);

    //pcbAssembly(RPI3A_plus);
    //pcbAssembly(RPI0);
    //pcbAssembly(BTT_SKR_MINI_E3_V2_0);
    //pcbAssembly(BTT_SKR_E3_TURBO);
    //Base_SKR_E3_Turbo_assembly();
    //Base_SKR_1_4_assembly();
    //baseLeftFeet();
    //baseLeftFeet(hardware=true);
    //baseRightFeet();
    //baseRightFeet(hardware=true);
    //Display_Cover_assembly();
    //Display_Housing_assembly();
    *rotate([90, 0, 180]) {
        //Front_Lower_Chord_SKR_1_4_Headless_stl();
        Front_Lower_Chord_stl();
    }
    //translate_z(_zMin) Print_bed_3_point_printed_assembly();
    //translate_z(_zMin) Print_bed_assembly();
    translate([0, eps, 2*eps]) {
        if (_useCNC) {
            IEC_Housing();
            IEC_hardware();
            //Right_Face_CF_assembly();
            //Left_Face_CF_assembly();
            //Back_Face_CF_Stage_1_assembly();
            //Back_Face_CF_assembly();
        } else {
            //Back_Face_assembly();
            Back_Face_Stage_1_assembly();
            Right_Face_assembly();
        }
        //Left_Face_assembly();
    }
    //rotate([90, 0, 0]) Front_Face_CF();
    //Front_Face_CF_assembly();

    *baseAllCornerHolePositions()
        cylinder(r=2, h=5);
}

if ($preview)
    Base_test();
else
    Base_stl();
