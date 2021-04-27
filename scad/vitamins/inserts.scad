include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/inserts.scad>

include <bolts.scad>

// tolerance for brassKnurl when printed vertically, ie against the print grain
brassKnurlToleranceVertical = 0.0;
brassKnurlTolerance = 0.2;
brassKnurl5x5Length = 5.2;

module brassKnurl5x5Hole(tolerance=brassKnurlTolerance, nutDepth=0) {
    depth = nutDepth == 0 ? brassKnurl5x5Length : nutDepth;
    translate_z(-eps) cylinder(d=4.6 + tolerance, h=depth + 2*eps);
}

module threadedHoleM3(length=0, tolerance=brassKnurlTolerance, useBrass5x5Knurl=true) {
    brassKnurl5x5Hole(tolerance);
    boltHoleM3(length);
}

module _threadedInsertM3() {
    boltColorBrass = "#B5A642";
    if ($preview&&is_undef($hide_bolts)) color(boltColorBrass) insert(F1BM3);
}

module boltHoleM3TapOrInsert(length, useInsert = false, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = false) {
    if (useInsert)
        insert_hole(F1BM3, horizontal = horizontal);
    else
        boltHole(M3_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}
