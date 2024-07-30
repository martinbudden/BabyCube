//!# Print Bed 3 Point Printed Assembly Instructions
//!
//!This is a alternative print bed for the BabyCube. It uses the same 120 x 120 x 6 mm aluminium tooling plate that is used on the
//![Voron0](https://vorondesign.com/voron0).
//!
//!![Print Bed 3 Point Printed Assembly](assemblies/Print_bed_3_point_printed_assembled.png)
//!
//!![printbed120](../pictures/printbed120_1000.jpg)
//
include <NopSCADlib/utils/core/core.scad>

use <printed/Printbed3point.scad>


module PRINTBED120E15_assembly() {
    //vflip() Print_bed_3_point_printed_Stage_1_assembly();
    Print_bed_3_point_assembly();
}

if ($preview)
    PRINTBED120E15_assembly();
