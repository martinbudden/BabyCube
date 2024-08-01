//! Display the front chords

use <../scad/printed/FrontChords.scad>


//$explode = 1;
//$pose = 1;
module FrontChords_test() {
    Front_Upper_Chord_stl();
    Front_Lower_Chord_stl();
    //Front_Lower_Chord_Solid_stl();
    //Front_Lower_Chord_SKR_1_4_Headless_stl();
}

if ($preview)
    FrontChords_test();
