include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/pcbs.scad>

include <DisplayHousing.scad>
use <FrontChords.scad>

include <../Parameters_Main.scad>


display_type = BTT_TFT35_V3_0();
displayBracketBackThickness = 5;
displayAngle = 45;


BTT_TFT35_V3_0 = [
    "BigTreeTech_TFT35v3_0", "BigTreeTech TFT35 v3.0",
    85.5, 54.5, 4,                  // size, screen is 84.5 wide, extra 1mm added to allow clearance of ribbon cable at side
    BigTreeTech_TFT35v3_0_PCB,      // pcb
    [6.5 - (110 - 85.5)/2, 0, 0],   // pcb offset from center
//    [ [-85.5/2 + 7, -25.5], [85.5/2 - 3.5, 25.5, 0.5] ],  // aperture
    [ [-85.5/2 + 7, -25], [85.5/2 - 3.5, 25, 0.5] ],    // aperture
    [ [-85.5/2 + 7, -25], [85.5/2 - 3.5, 25, 0.25] ],   // touch screen position and size
    0,                                                  // length that studs protrude from the PCB holes
    [ [-85.5/2 - 1, -54.5/2], [-85.5/2, 54.5/2, 0.5] ],  // keep out region for ribbon cable
];


function BTT_TFT35_V3_0(size = [85.5, 54.5, 6], pcbSize = [110, 55.77, 1.6]) = [
    "BigTreeTech_TFT35v3_0", "BigTreeTech TFT35 v3.0",
    size.x, size.y, size.z,                  // size, screen is 84.5 wide, extra 1mm added to allow clearance of ribbon cable at side
    BigTreeTech_TFT35v3_0_PCB,      // pcb
    [6.5 - (pcbSize.x - size.x)/2, 0, 0],   // pcb offset from center
    [ [-size.x/2 + 7, -size.y/2 + 2.25], [size.x/2 - 3.5, size.y/2 - 2.25, 0.5] ],    // aperture
    [ [-size.x/2 + 7, -size.y/2 + 2.25], [size.x/2 - 3.5, size.y/2 - 2.25, 0.25] ],   // touch screen position and size
    0,                                                      // length that studs protrude from the PCB holes
    [ [-size.x/2 - 1, -size.y/2], [-size.x/2, size.y/2, 0.5] ],  // keep out region for ribbon cable
];
//BTT_TFT35_V3_0 = BigTreeTech_TFT35v3_0;

module Display_Housing_stl() {
    stl("Display_Housing")
        color(pp2_colour)
            displayHousing(display_type, displayBracketBackThickness);
}

module Display_Housing_Bracket_stl() {
    stl("Display_Housing_Bracket")
        rotate([-90, 0, 0])
            difference() {
                color(pp1_colour)
                    displayHousingBracket(display_type, displayBracketBackThickness, displayAngle);
                // bolt holes on the back of the bracket
                displayBracketHolePositions(display_type, displayBracketBackThickness, displayAngle)
                    boltHoleM3Tap(8);
            }
}

//! Place the display into the housing and secure it with the bolts - use the bolts to self-tap the holes in the housing.
//! Attach the knob to the display.
module Display_Cover_assembly()  pose(a=[55 + 45, 0, 25 + 95])
assembly("Display_Cover", big=true, ngb = true) {

    translate([eX/2 + eSizeX, -displayBracketBackThickness, 0])
        displayHousingLocate(displayHousingSize(display_type), displayAngle) {
            stl_colour(pp2_colour)
                Display_Housing_stl();
            displayHousingHardware(display_type);
            pcb_screw_positions(display_pcb(display_type))
                translate_z(7.6)
                    explode(40, true)
                        boltM3Caphead(6);
        }
}

module displayHousingAssembly() {
    translate_z(-1) {
        explode([0, -40, 40])
            Display_Cover_assembly();
        translate([eX/2 + eSizeX, -displayBracketBackThickness, 0]) {
            displayHousingLocate(displayHousingSize(display_type), displayAngle)
                displayHousingBoltPositions(display_type)
                    vflip()
                        explode(60, true)
                            boltM3Caphead(useCounterbore() ? 16 : 20);
            rotate([90, 0, 0])
                stl_colour(pp1_colour)
                    Display_Housing_Bracket_stl();
        }
    }
}

module Display_Housing_CF_assembly()
assembly("Display_Housing_CF", big=true) {
    displayHousingAssembly();
}

//! 1. Bolt the **Display_Cover_assembly** to the **Display_Housing_Bracket**.
//! 2. Bolt the **Display_Housing_Bracket** to **the Front_Lower_Chord**.
module Display_Housing_assembly()
assembly("Display_Housing", big=true) {
    displayHousingAssembly();
    explode([0, 40, 0], true)
        rotate([90, 0, 180]) {
            stl_colour(pp2_colour)
                Front_Lower_Chord_stl();
            explode(15, true)
                Front_Lower_Chord_hardware();
        }
}
