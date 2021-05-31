include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/rounded_triangle.scad>
include <NopSCADlib/vitamins/bearing_blocks.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>
include <NopSCADlib/vitamins/screws.scad>
use <NopSCADlib/vitamins/sheet.scad>

use <../vitamins/bolts.scad>

include <Printbed.scad>
use <Z_carriage.scad>

include <../Parameters_Main.scad>


AL6anodised = [ "AL6anodised",       "Aluminium tooling plate", 6, [0.3, 0.3, 0.3, 1 ], false];

scs_type = _zRodDiameter == 8 ? SCS8UU : _zRodDiameter == 10 ? SCS10UU : SCS12UU;
leadnut = LSN8x2;
leadnutInset = leadnut_flange_t(leadnut) + 7.5;
eSize = 15;

printBed3pointBaseOffsetZ = underlayThickness + + heatingPadThickness + sheet_thickness(AL6anodised) + magneticBaseThickness + printSurfaceThickness;

heatedBedSize = _printBedSize == 120 ? [120, 120, 6] : _printBedSize == 180 ? [180, 180, 6] : [120, 120, 6];
heatedBedHoleOffset = 5;

module headedBed() {
    size = heatedBedSize;

    color(grey(30))
        difference() {
            not_on_bom() sheet(AL6anodised, size.x, size.y, 1);
            // holes are on 110mm spacing
            for ( i = [ [0, -size.y/2 + heatedBedHoleOffset, -size.z/2 - eps],
                        [-size.x/2 + heatedBedHoleOffset, size.y/2 - heatedBedHoleOffset, -size.z/2 - eps],
                        [size.x/2 - heatedBedHoleOffset, size.y/2 - heatedBedHoleOffset, -size.z/2 - eps]
                ])
                translate(i) {
                    cylinder(r=M3_clearance_radius, h=size.z + 2*eps);
                    offset = 2;
                    translate_z(size.z - offset + eps)
                        cylinder(r=3.3, h=offset);
                    translate_z(size.z - offset + 2*eps)
                        screw_countersink(M3_cs_cap_screw);
                }
        }
}

module Heated_Bed() {
    size = heatedBedSize;
    vitamin(str("Heated_Bed(): Aluminium tooling plate ", size.x, "mm x ", size.y, "mm x ", size.z, "mm"));

    translate_z(size.z/2)
        render_sheet(AL6anodised, w=size.x, d=size.y)
            headedBed();

    if ($children)
        translate_z(size.z)
            children();
}

module extrusionOX(length, eSize=20) {
    frameColor = [135/255, 145/255, 155/255];
    if (is_undef($hide_extrusions))
        translate([0, eSize/2, eSize/2])
            rotate([0, 90, 0])
                color(frameColor)
                    extrusion(eSize==15 ? E1515 : E2020, length, center=false);
}

module extrusionOY(length, eSize=20) {
    translate([0, length, 0])
        rotate([0, 0, -90])
            extrusionOX(length, eSize);
}

module printbed3pointFrame() {
    scsSize = scs_size(scs_type);
    yExtrusionLength = (floor(heatedBedSize.y/50) + 1)*50;
    bracketThickness = 5;

    for (x = [_zRodSeparation/2 - scs_hole_offset(scs_type) - eSize - bracketThickness - 1, scs_hole_offset(scs_type) + bracketThickness + 1 - _zRodSeparation/2])
        translate([x, -scsSize.x/2, 0])
            extrusionOY(yExtrusionLength, eSize);

    xExtrusionLength = (floor(heatedBedSize.x/50) + 1)*50;
    translate([-xExtrusionLength/2, yExtrusionLength - scsSize.x/2, 0])
        extrusionOX(xExtrusionLength, eSize);
}

module scs_bearing_block_hole_positions_x(type) {
    screw_separation_x = scs_screw_separation_x(type);
    h = scs_hole_offset(type);

    for(x = [-screw_separation_x, screw_separation_x])
        translate([x / 2, -h, scs_screw_separation_z(type)/2])
            rotate([-90, 0, 0])
                children();
}

module printBed3pointFrameSideBrackets(armSize) {
    scsSize = scs_size(scs_type);
    fillet = 1;
    frameOffsetX = _zRodSeparation/2  - scsSize.y/2 - 1;
    sideBracketThickness = 6;
    sideBracketSize = [sideBracketThickness, scsSize.x, scsSize.z + 1];
    sideBracketBraceSize = [scsSize.z - eSize, 1.5, sideBracketThickness]; // x value of scsSize.z - eSize for full size

    difference() {
        translate([frameOffsetX, -scsSize.x/2, 0]) {
            if (!is_undef(armSize))
                translate([-armSize.x, 0, 0])
                    rounded_cube_xy(armSize + [0, 10, 0], fillet);
            translate([-sideBracketSize.x, 0, eSize - sideBracketSize.z])
                rounded_cube_xy(sideBracketSize, fillet);
            *translate([-sideBracketSize.x, sideBracketSize.y, 0])
                rotate([0, 90, 0])
                    rounded_right_triangle(sideBracketBraceSize.x, sideBracketBraceSize.y, sideBracketBraceSize.z, fillet, center=false, offset=true);
        }
        translate([_zRodSeparation/2, 0, eSize - scsSize.z/2]) {
            rotate(-90)
                scs_bearing_block_hole_positions_x(scs_type)
                    vflip()
                        boltHoleM3Tap(eSize);
            translate_z(-scs_screw_separation_z(scs_type))
                rotate(-90)
                    scs_bearing_block_hole_positions_x(scs_type)
                        translate_z(-sideBracketThickness)
                            boltHoleM5(sideBracketThickness, horizontal=true, chamfer=5, chamfer_both_ends=false);
        }
    }
    difference() {
        translate([-frameOffsetX, -scsSize.x/2, 0]) {
            if (!is_undef(armSize))
                rounded_cube_xy(armSize + [0, 10, 0], fillet);
            translate_z(eSize - sideBracketSize.z)
                rounded_cube_xy(sideBracketSize, fillet);
            *translate([0, sideBracketSize.y, 0])
                rotate([0, 90, 0])
                    rounded_right_triangle(sideBracketBraceSize.x, sideBracketBraceSize.y, sideBracketBraceSize.z, fillet, center=false, offset=true);
        }

        translate([-_zRodSeparation/2, 0, eSize - scsSize.z/2]) {
            rotate(90)
                scs_bearing_block_hole_positions_x(scs_type)
                    vflip()
                        boltHoleM3Tap(eSize);
            translate_z(-scs_screw_separation_z(scs_type))
                rotate(90)
                    scs_bearing_block_hole_positions_x(scs_type)
                        translate_z(-sideBracketThickness)
                            boltHoleM5(sideBracketThickness, horizontal=true, chamfer=5, chamfer_both_ends=false);
        }
    }
}

module Printbed_Frame_stl() {
    scsSize = scs_size(scs_type);
    armSize = [10, (floor(heatedBedSize.y/50) + 1)*50, eSize];
    endPieceSize = [heatedBedSize.x, 10, eSize];
    fillet = 1;
    frameOffsetX = _zRodSeparation/2  - scsSize.y/2 - 1;

    stl("Printbed_Frame")
        color(pp1_colour)
        vflip() {
            translate([-endPieceSize.x/2, armSize.y - scsSize.x/2 + (eSize - endPieceSize.y)/2, 0]) {
                difference() {
                    rounded_cube_xy(endPieceSize, fillet);
                    for (x = [ -heatedBedSize.x/2 + heatedBedHoleOffset, heatedBedSize.x/2 - heatedBedHoleOffset] )
                        translate([x + endPieceSize.x/2, endPieceSize.y/2, 0])
                            boltHoleM3Tap(eSize);
                }
                translate([endPieceSize.x/2 - frameOffsetX, 0, 0])
                    rotate(180)
                        fillet(5, eSize);
                translate([endPieceSize.x/2 - frameOffsetX + armSize.x, 0, 0])
                    rotate(270)
                        fillet(5, eSize);
                translate([endPieceSize.x/2 + frameOffsetX, 0, 0])
                    rotate(270)
                        fillet(5, eSize);
                translate([endPieceSize.x/2 + frameOffsetX - armSize.x, 0, 0])
                    rotate(180)
                        fillet(5, eSize);
            }
            crossPieceSize = [_zRodSeparation - scsSize.y - 2 - armSize.x, 10, 5];
            translate([-crossPieceSize.x/2, armSize.y/2, eSize])
                vflip()
                    zCarriageCrossPiece(crossPieceSize, armSize.x);

            printBed3pointFrameSideBrackets(armSize);

            render(convexity=8)
                difference() {
                    linear_extrude(eSize)
                        difference() {
                            union() {
                                squareSize = [_zRodSeparation - scsSize.y - 2 - 2*armSize.x, 55];
                                translate([-squareSize.x/2, -scsSize.x/2, 0]) {
                                    translate([-fillet, 0])
                                        square([squareSize.x + 2*fillet, squareSize.y], center=false);
                                    translate([0, squareSize.y])
                                        fillet(5);
                                    translate(squareSize)
                                        rotate(90)
                                            fillet(5);
                                }
                            }
                            poly_circle(r=leadnut_od(leadnut)/2);
                        }
                    leadnut_screw_positions(leadnut)
                        boltHoleM3Tap(eSize);
                    poly_cylinder(r=leadnut_flange_dia(leadnut)/2, h=leadnutInset + 2*eps);
                    translate([0, armSize.y - heatedBedSize.y + eSize/2 + 2*heatedBedHoleOffset - scsSize.x/2, 0])
                        boltHoleM3Tap(eSize);
                }
        }
}

module Printbed_Bracket_stl() {
    scsSize = scs_size(scs_type);
    cubeSize = [_zRodSeparation - scsSize.y - 2, 25, 5];

    stl("Printbed_Bracket")
        color(pp1_colour) {
            linear_extrude(cubeSize.z)
                difference() {
                    rounded_square(vec2(cubeSize), 3, center=true);
                    circle(d=leadnut_od(leadnut));
                    leadnut_screw_positions(leadnut)
                        circle(r=M3_tap_radius);
                }
            translate_z(-eSize)
                printBed3pointFrameSideBrackets();
        }
}

module printbed3point(leadnutOffset=eSize/2, scsOffset=0) {

    translate([_zRodSeparation/2, 0, scsOffset + eSize/2])
        rotate(-90)
            scs_bearing_block(scs_type);
    translate([-_zRodSeparation/2, 0,  scsOffset + eSize/2])
        rotate(90)
            scs_bearing_block(scs_type);

    scsSize = scs_size(scs_type);
    yExtrusionLength = (floor(heatedBedSize.y/50) + 1)*50;
    translate([0, yExtrusionLength - heatedBedSize.y/2 + eSize/2 + heatedBedHoleOffset - scsSize.x/2, eSize]) {
        printBedSize = 120;
        corkUnderlay([heatedBedSize.x, heatedBedSize.y, underlayThickness], printBedSize)
            heatingPad([100, 100, heatingPadThickness])
                Heated_Bed()
                    magneticBase(printBedSize, magneticBaseThickness, holeRadius = 3);
    }

    translate_z(leadnutOffset + eSize/2)
        vflip() {
            leadnut(leadnut);
            leadnut_screw_positions(leadnut)
                screw(leadnut_screw(leadnut), 8);
        }

    translate([_zRodSeparation/2 - 6 - eps, 0, eSize - scsSize.z/2 - scs_screw_separation_z(scs_type)])
        rotate(-90)
            scs_bearing_block_hole_positions_x(scs_type)
                vflip()
                    boltM5Countersunk(12);

    translate([-_zRodSeparation/2 + 6 + eps, 0, eSize - scsSize.z/2 - scs_screw_separation_z(scs_type)])
        rotate(90)
            scs_bearing_block_hole_positions_x(scs_type)
                vflip()
                    boltM5Countersunk(12);
}

module Print_bed_3_point_assembly()
assembly("Print_bed_3_point") {

    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, -eSize - printBed3pointBaseOffsetZ]) // this moves it to the back face
        rotate(180) {
            printbed3point(scsOffset=-scs_screw_separation_z(scs_type)/2);
            printbed3pointFrame();
            translate_z(eSize)
                stl_colour(pp1_colour)
                    Printbed_Bracket_stl();
        }
}

module Print_bed_3_point_printed_assembly()
assembly("Print_bed_3_point_printed") {

    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, -eSize - printBed3pointBaseOffsetZ]) // this moves it to the back face
        rotate(180) {
            printbed3point(-eSize/2 + leadnutInset, (eSize - scs_size(scs_type).z)/2);
            vflip()
                stl_colour(pp1_colour)
                    Printbed_Frame_stl();
        }
}
