include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/dogbones.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/sheets.scad>

include <../utils/cutouts.scad>
include <../utils/HolePositions.scad>

include <../vitamins/bolts.scad>

use <DisplayHousing.scad>
use <DisplayHousingAssemblies.scad>
use <FrontChords.scad>
use <LeftAndRightFaces.scad>
use <XY_IdlerBracket.scad>

include <../Parameters_CoreXY.scad>


module Front_Face_CF_dxf() {
    dxf("Front_Face_CF")
        frontFaceCF(coverBelts = true);
}

module frontFaceCF(coverBelts) {
    size = [eX + 2*eSizeX, eZ];
    insetX = idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z;
    insetX2 = 10;
    insetY = 21;

    difference() {
        sheet_2D(CF3, size.x, size.y);
        translate([-size.x/2, -size.y/2]) {
            translate([insetX, 50])
                rounded_square([size.x - 2*insetX, eZ - insetY - 50 - (coverBelts ? 24 : 0)], 3, center=false);
            if (coverBelts) {
                for (x = [18.5, size.x - 18.5])
                    translate([x, eZ - insetY - 10])
                        rounded_square([12, 20], 1.5, center=true);
            } else {
                #translate([insetX2, eZ - insetY - 20])
                    rounded_square([size.x - 2*insetX2, 20], 2, center=false);
                translate([insetX, eZ - insetY - 20])
                    rotate(180)
                        fillet(2);
                translate([size.x - insetX, eZ - insetY - 20])
                    rotate(270)
                        fillet(2);
            }
            backFaceSideCutouts(cnc=true, plateThickness=_frontPlateCFThickness, dogBoneThickness=0);
            backFaceTopCutouts(cnc=true, plateThickness=_backPlateCFThickness, dogBoneThickness=0);
            railsCutout(_xyNEMA_width, yRailOffset(_xyNEMA_width), cnc=true);
            frontFaceHolePositions()
                circle(r=M3_clearance_radius);
            frontFaceLowerHolePositions()
                circle(r=M3_clearance_radius);
            if (_useFrontSwitch)
                translate([rockerPosition(rocker_type()).z, rockerPosition(rocker_type()).y])
                    rocker_hole(rocker_type(), 0, rounded=false);

            if (_useFrontDisplay) {
                display_type = BigTreeTech_TFT35v3_0;
                /*cutoutSize = frontChordCutoutSize(display_type);
                cutoutOffset = frontChordCutoutOffset(display_type);
                translate([size.x + cutoutOffset.x, cutoutOffset.y])
                    rounded_square([cutoutSize.x, cutoutSize.y], 2, center = false);*/
                translate([size.x/2, -1])
                    displayBracketHolePositionsCNC(display_type)
                        circle(r=M3_clearance_radius);
                frontLowerChordSKR_1_4_cutout(display_type, cnc=true);
            }
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
        if (_useFrontSwitch)
            translate([rockerPosition(rocker_type()).z, rockerPosition(rocker_type()).y])
                rocker(rocker_type(), "red");
    }
    if (_useFrontSwitch)
        explode([0, -30, 0], true) {
            Display_Housing_CF_assembly();
            translate([eX/2 + eSizeX, -2, 0])
                displayBracketHolePositions(BigTreeTech_TFT35v3_0)
                    vflip()
                        explode(60)
                            boltM3Buttonhead(10);
        }
}
