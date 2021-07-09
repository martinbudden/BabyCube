//! Display a ADXL345 pcb

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>

include <../scad/vitamins/pcbs.scad>


module ADXL345_test() {
    pcb = ADXL345;
    //echo(holes=pcb_holes(pcb));
    echo(holeSeparation=pcb_size(pcb).x - pcb_holes(pcb)[0].x + pcb_holes(pcb)[1].x);
    pcb(pcb);
}

if ($preview)
    ADXL345_test();
