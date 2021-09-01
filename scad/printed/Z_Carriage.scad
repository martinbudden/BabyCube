include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/rounded_triangle.scad>
include <NopSCADlib/vitamins/leadnuts.scad>
include <NopSCADlib/vitamins/linear_bearings.scad>
use <NopSCADlib/vitamins/o_ring.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
use <NopSCADlib/vitamins/wire.scad>

use <../utils/ziptieCutout.scad>

use <../vitamins/bolts.scad>

include <../Parameters_Main.scad>


/*function heatedBedSize() =
    eY < 250 ? [100, 100, 1.6] :
    eY < 300 ? [180, 180, 3] :
    [235, 235, 3];

function heatedBedHoleOffset() = heatedBedSize().x == 100 ? 4 : heatedBedSize().x < 235 ? 2.5 : 32.5;
*/
function heatedBedSize(printBedSize) =
    printBedSize == 100 ? [100, 100, 1.6] : // Openbuilds mini heated bed size
    printBedSize == 120 ? [120, 120, 6] : // Voron 0 size
    printBedSize == 180 ? [180, 180, 3] :
    undef;

// values marked undef are not currently reliably known
function heatedBedHoleOffset(printBedSize) =
    printBedSize == 100 ? 4 :
    printBedSize == 120 ? 5 :
    printBedSize == 180 ? 3 : // !!estimate
    undef;

// Y offset is from leadscrew
function heatedBedOffset(printBedSize) = [0, printBedSize==120 ? 12 : 22, 0];

function heatedBedHoles(printBedSize, _holeOffset=undef) =
    let(size = heatedBedSize(printBedSize),
        holeOffset = is_undef(_holeOffset) ? heatedBedHoleOffset(printBedSize) : _holeOffset)
    (printBedSize == 120 ?
        [
            [  0, -(size.y/2 - holeOffset), 0 ],
            [  size.x/2 - holeOffset,    size.y/2 - holeOffset,  0 ],
            [-(size.x/2 - holeOffset),   size.y/2 - holeOffset,  0 ]
        ] :
        [
            [-(size.x/2 - holeOffset), -(size.y/2 - holeOffset), 0 ],
            [  size.x/2 - holeOffset,  -(size.y/2 - holeOffset), 0 ],
            [  size.x/2 - holeOffset,    size.y/2 - holeOffset,  0 ],
            [-(size.x/2 - holeOffset),   size.y/2 - holeOffset,  0 ]
        ]);


bearing_type = _zRodDiameter == 8 ? LM8LUU : _zRodDiameter == 10 ? LM10LUU : LM12LUU;
leadnut = LSN8x2;
leadnutInset = leadnut_flange_t(leadnut) + 2.5;
tubeDiameter = bearing_dia(bearing_type) + 6;
baseThickness = 10;
extraArmLength = 5;
function armSize(printBedSize) = [15, heatedBedSize(printBedSize).y + heatedBedOffset(printBedSize).y + extraArmLength, baseThickness];
bearingOffset = 0;
function crossPieceSize(armSeparation=0) = [armSeparation, 10, 5];

module zCarriageCrossPiece(crossPieceSize, armSizeX) {
    crossPieceFillet = 3;

    difference() {
        cube(crossPieceSize);
        translate([crossPieceSize.x/2, crossPieceSize.y/2, crossPieceSize.z])
            zipTieFullCutout();
    }
    translate([armSizeX/2, 0, 0])
        rotate(-90)
            fillet(crossPieceFillet, crossPieceSize.z);
    translate([armSizeX/2, crossPieceSize.y, 0])
        fillet(crossPieceFillet, crossPieceSize.z);
    translate([crossPieceSize.x-armSizeX/2, 0, 0])
        rotate(180)
            fillet(crossPieceFillet, crossPieceSize.z);
    translate([crossPieceSize.x-armSizeX/2, crossPieceSize.y, 0])
        rotate(90)
            fillet(crossPieceFillet, crossPieceSize.z);
}

module zCarriage(printBedSize, testing=false) {
    armSeparation = printBedSize==100 ? _zRodSeparation - 5 : _zRodSeparation + 18;
    armSize = armSize(printBedSize);
    supportSize = [_zRodSeparation, tubeDiameter + 4, baseThickness];

    //echo("zc hbo", heatedBedOffset());
    //echo("zc ym, dd", _yMax, eY + 2*eSizeY- heatedBedOffset().y - _zLeadScrewOffset);

    difference() {
        union() {
            for (x = [-_zRodSeparation/2, _zRodSeparation/2])
                translate([x, 0, 0]) {
                    cylinder(d=tubeDiameter, h=testing ? 25 : bearing_length(bearing_type) - bearingOffset);
                    cylinder(d=supportSize.y, h=testing ? 25 : supportSize.z);
                }
            // the brace between the two bearing holders
            translate([-supportSize.x/2, -supportSize.y/2, 0])
                //cube(supportSize - [0, 0, leadnutInset]);// for debug
                cube(supportSize);
            support2Size = [armSeparation, 5, baseThickness];
            translate([-support2Size.x/2, supportSize.y/2, 0])
                cube(support2Size);
            if (!testing) {
                crossPieceSize = crossPieceSize(armSeparation);
                for (y = printBedSize == 100 ?
                        [heatedBedOffset(printBedSize).y + 20, heatedBedOffset(printBedSize).y + heatedBedSize(printBedSize).y - 20]
                        : [heatedBedOffset(printBedSize).y + heatedBedSize(printBedSize).y - 8])
                    translate([-armSeparation/2, y, 0]) {
                        zCarriageCrossPiece(crossPieceSize, armSize.x);
                }
                // the arms
                for (x = [-armSeparation/2, armSeparation/2])
                    translate([x-armSize.x/2, 0])
                        rounded_cube_xy(armSize, 2);
                translate([-armSeparation/2 + armSize.x/2, supportSize.y/2 + support2Size.y, 0])
                    fillet(5, armSize.z);
                translate([armSeparation/2 - armSize.x/2, supportSize.y/2 + support2Size.y, 0])
                    rotate(90)
                        fillet(5, armSize.z);
                triangleFillet = 1;
                triangleWidth = 7;
                braceSeparation = (_zRodSeparation - 5 + armSize.x - triangleWidth) + (printBedSize == 120 ? 8 : 0);
                for (x = [-braceSeparation/2, braceSeparation/2])
                    translate([x, supportSize.y/2 - 2*triangleFillet - (printBedSize == 120 ? 5 : 4), 8])
                        rotate([90, 0, 90]) {
                            rounded_right_triangle(armSize.y - 12, bearing_length(bearing_type) - bearingOffset - 34, triangleWidth, triangleFillet, offset = false);
                            rounded_right_triangle(20, bearing_length(bearing_type) - bearingOffset - 8, triangleWidth, triangleFillet, offset = false);
                        }
            } // end testing
        } // end union
        for (x = [-_zRodSeparation/2, _zRodSeparation/2])
            translate([x, 0, -eps]) {
                poly_cylinder(r=bearing_dia(bearing_type)/2, h=bearing_length(bearing_type) + 2*eps);
                cut = 1.5;
                rotate(x < 0 ? -90 : -90)
                    translate([0, -cut/2, 0*(layer_height + eps)])
                        cube([supportSize.y/2 + eps, cut, bearing_length(bearing_type) + 2*eps]);
            }
        translate_z(-eps) {
            //echo("leadnut_od, coupling_od", leadnut_od(leadnut), sc_diameter(SC_5x8_rigid));
            //grubScrewClearance = 1.0;
            //poly_cylinder(r = sc_diameter(SC_5x8_rigid)/2 + grubScrewClearance, h = supportSize.z + 2*eps);
            poly_cylinder(r = leadnut_od(leadnut)/2, h = supportSize.z + 2*eps);
            translate_z(supportSize.z - leadnutInset)
                poly_cylinder(r = leadnut_flange_dia(leadnut)/2, h = leadnutInset + 2*eps);
            translate_z(-supportSize.z/2)
                leadnut_screw_positions(leadnut)
                    rotate(27) // rotate the poly cylinders to give a bit more clearance from the center hole
                        poly_cylinder(r=screw_pilot_hole(leadnut_screw(leadnut)), h=supportSize.z + 2);
        }
        translate([0, heatedBedSize(printBedSize).y/2 + heatedBedOffset(printBedSize).y, 0])
            for (i = heatedBedHoles(printBedSize) )
                translate(i)
                    boltHoleM3Tap(supportSize.z);
    } // end difference
}

module Z_Carriage_cable_ties(printBedSize) {
    crossPieceSize = crossPieceSize();
    for (y = printBedSize == 100 ?
            [heatedBedOffset(printBedSize).y + 20, heatedBedOffset(printBedSize).y + heatedBedSize(printBedSize).y - 20]
            : [heatedBedOffset(printBedSize).y + heatedBedSize(printBedSize).y - 8])
        translate([2.75, y + crossPieceSize.y/2, -crossPieceSize.z])
            rotate([-90, 0, 90])
                cable_tie(cable_r=3, thickness=1);
}

module zCarriage_hardware() {
    brassColor = "#B5A642";
    explode(-20, true) {
        *translate_z(-leadnut_flange_t(leadnut)) {
            color(brassColor)
                leadnut(leadnut);
            translate_z(-leadnut_flange_t(leadnut))
                leadnut_screw_positions(leadnut)
                    vflip()
                        screw(leadnut_screw(leadnut), 8);
        }
        translate_z(baseThickness - leadnutInset) {
            explode(50)
                color(brassColor)
                    leadnut(leadnut);
            explode(80)
                leadnut_screw_positions(leadnut)
                    screw(leadnut_screw(leadnut), 8);
        }
    }
    for (x = [-_zRodSeparation/2, _zRodSeparation/2])
        translate([x, 0, 0])
            translate_z(bearing_length(bearing_type)/2 - bearingOffset)
                explode(80)
                    linear_bearing(bearing_type);
}

module Z_Carriage_stl() {
    stl("Z_Carriage")
        color(pp4_colour)
            zCarriage(_printBedSize);
}

//! Slide the linear bearings into the Z_Carriage.
//!
//! Affix the leadscrew nut.
module Z_Carriage_assembly()
assembly("Z_Carriage", big=true, ngb=true) {
     hflip() {
        stl_colour(pp4_colour)
            Z_Carriage_stl();
        zCarriage_hardware();
    }
}
