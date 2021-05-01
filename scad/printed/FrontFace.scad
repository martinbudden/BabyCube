include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/dogbones.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/sheets.scad>

use <../utils/cutouts.scad>
use <../utils/HolePositions.scad>

use <../vitamins/bolts.scad>

use <DisplayHousing.scad>
use <DisplayHousingAssemblies.scad>
use <FrontChords.scad>
use <LeftAndRightFaces.scad>
use <XY_IdlerBracket.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module Front_Face_CF_dxf() {
    size = [eX + 2*eSizeX, eZ];
    insetX = idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z;
    insetY = 21;

    dxf("Front_Face_CF")
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2]) {
                translate([insetX, 50])
                    rounded_square([size.x - 2*insetX, eZ - insetY - 50], 3, center=false);
                backFaceSideCutouts(cnc=true, plateThickness=_frontPlateCFThickness, dogBoneThickness=0);
                translate([rockerPosition(rocker_type()).z, rockerPosition(rocker_type()).y])
                    rocker_hole(rocker_type(), 0, rounded = false);

                display_type = BigTreeTech_TFT35v3_0;
                /*cutoutSize = frontChordCutoutSize(display_type);
                cutoutOffset = frontChordCutoutOffset(display_type);
                translate([size.x + cutoutOffset.x, cutoutOffset.y])
                    rounded_square([cutoutSize.x, cutoutSize.y], 2, center = false);*/
                translate([size.x/2, -1])
                    displayBracketHolePositionsCNC(display_type)
                        circle(r=M3_clearance_radius);
                frontLowerChordSKR_1_4_cutout(display_type, cnc=true);
                railsCutout(_xyNEMA_width, yRailOffsetXYZ(_xyNEMA_width), cnc=true);
            }
        }
}

module Front_Face_CF() {
    size = [eX + 2*eSizeX, eZ];

    translate([size.x/2, size.y/2, -_backPlateCFThickness])
        render_2D_sheet(CF3, w=size.x, d=size.y)
            Front_Face_CF_dxf();
    translate([size.x/2, size.y - 11])
        color(grey(95))
            linear_extrude(1)
                text(_cubeName, size=14, font="Calibri", halign="center", valign="center");
}

module Front_Face_CF_assembly()
assembly("Front_Face_CF") {
    rotate([90, 0, 0]) {
        Front_Face_CF();
        translate([rockerPosition(rocker_type()).z, rockerPosition(rocker_type()).y])
            rocker(rocker_type(), "red");
    }
    explode([0, -30, 0], true) {
        Display_Housing_CF_assembly();
        translate([eX/2 + eSizeX, -2, 0])
            displayBracketHolePositions(BigTreeTech_TFT35v3_0)
                vflip()
                    explode(60)
                        boltM3Buttonhead(10);
    }
}
