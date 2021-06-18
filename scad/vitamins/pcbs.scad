include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>


ADXL345  = [
    "ADXL345 1", "ADXL345 ",
    inch(0.8), inch(0.6), 1.6, // size
    0, // corner radius
    3, // mounting hole diameter
    0, // pad around mounting hole
    "#2140BE", // color
    false, // true if parts should be separate BOM items
    [ [2.9, -2.5], [-2.9, -2.5] ], // hole positions
    [ // components
        [ inch(0.4),  inch(0.35),  0, "chip", 5,  3, 1.1,  grey(15) ],
    ],
    [], // accessories
    [inch(0.1)/2, inch(0.1)/2, 8, 1], // 8x1 grid of holes
];
