//!# Print Bed 3 Point Printed Assembly Instructions
//!
//!This is a alternative print bed for the BabyCube. It uses the same 120 x 120 x 6 mm aluminium tooling plate that is used on the
//![Voron0](https://vorondesign.com/voron0).
//!
//!![Print Bed 3 Point Printed Assembly](assemblies/Print_bed_3_point_printed_assembled.png)
//!
//!![printbed120](../pictures/printbed120_1000.jpg)
//
include <NopSCADlib/core.scad>

use <printed/Printbed3point.scad>


module PRINTBED120_assembly() {
    Print_bed_3_point_printed_assembly();
}

if ($preview)
    PRINTBED120_assembly();
