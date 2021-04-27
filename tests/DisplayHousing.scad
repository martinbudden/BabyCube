//! Display the housing for the BigTreeTech_TFT35_V3_0

include <../scad/global_defs.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/pcbs.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/DisplayHousingAssemblies.scad>
use <../scad/printed/FrontChords.scad>


//$explode = 1;
//$pose = 1;
module DisplayHousing_test() {
    //assert(BTT_TFT35_V3_0==BTT_TFT35_V3_0());
    display_type = BTT_TFT35_V3_0();

    *translate_z(-1)
    for (testLayer = [1, 2])
    displayHousingBase(display_type, testLayer=testLayer);
    //displayHousingBase(BigTreeTech_TFT35_E3_V3_0, fillet = 2);
    *displayHousingAssembly();
    *Display_Cover_assembly();
    *Display_Housing_assembly();
    *translate([120, 0, 0])
        Display_Housing_BTT_TFT35_E3_V3_0_assembly();

    *displayHousingLocate(displayHousingSize(display_type), angle=45)
        Display_Housing_stl();
    rotate([90, 0, 0])
        Display_Housing_Bracket_stl();

    //pcbType = BTT_SKR_MINI_E3_V2_0;
    pcbType = BTT_SKR_V1_4_TURBO;
    *translate_z(pcbOffsetFromBase())
        pcbPosition(pcbType)
            pcb(pcbType);


    *rotate([90, 0, 180])
        Front_Lower_Chord_stl();
}

if ($preview)
    DisplayHousing_test();
