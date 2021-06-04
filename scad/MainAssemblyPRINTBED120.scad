//!# Print Bed 3 Point Printed Assembly Instructions
//!
//!
//!![Print Bed 3 Point Printed Assembly](assemblies/Print_bed_3_point_printed_assembled.png)
//
include <NopSCADlib/core.scad>

use <printed/Printbed3point.scad>


module PRINTBED120_assembly() {
    Print_bed_3_point_printed_assembly();
}

if ($preview)
    PRINTBED120_assembly();
