include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/rounded_triangle.scad>
include <NopSCADlib/vitamins/bearing_blocks.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>
use <NopSCADlib/vitamins/o_ring.scad>
include <NopSCADlib/vitamins/screws.scad>
use <NopSCADlib/vitamins/sheet.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../vitamins/bolts.scad>

use <../utils/translateRotate.scad>
include <Printbed.scad>
use <Z_Carriage.scad>
include <../utils/StagedAssembly.scad>

include <../config/Parameters_Main.scad>

AL6anodised = [ "AL6anodised",       "Aluminium tooling plate", 6, [0.3, 0.3, 0.3, 1 ], false];

scs_type = _zRodDiameter == 8 ? SCS8UU : _zRodDiameter == 10 ? SCS10UU : SCS12UU;
leadnut = LSN8x2;
leadnutInset = leadnut_flange_t(leadnut) + 7.5;
eSize = 15;

printBed3pointBaseOffsetZ = underlayThickness + heatingPadThickness + sheet_thickness(AL6anodised) + magneticBaseThickness + printSurfaceThickness;

heatedBedSize = _printBedSize == 120 ? [120, 120, 6] : _printBedSize == 180 ? [180, 180, 6] : [120, 120, 6];
heatedBedHoleOffset = 5;
heatedBedOffsetE1515 = 0;

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
    vitamin(str("Heated_Bed(): Voron V0 aluminium build plate ", size.x, "mm x ", size.y, "mm x ", size.z, "mm"));

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

module jointBoltHole() {
    extrusionChannelDepth = (extrusion_width(E1515) - extrusion_center_square_wd(E1515))/2;
    translate_z(extrusionChannelDepth - eps)
        cylinder(d = 4, h = eSize - 2*extrusionChannelDepth + 2*eps);
}

module printbed3pointFrame(zRodSeparation) {
    scsSize = scs_size(scs_type);
    yExtrusionLength = (floor(heatedBedSize.y/50) + 1)*50 + heatedBedOffsetE1515;
    bracketThickness = 5;

    xs = [zRodSeparation/2 - scs_hole_offset(scs_type) - eSize, scs_hole_offset(scs_type) - zRodSeparation/2];
    for (x = xs)
        translate([x, -scsSize.x/2, 0]) {
            extrusionOY(yExtrusionLength, eSize);
            translate([eSize/2, yExtrusionLength + 1.8, eSize/2])
                rotate([-90, 0, 0]) {
                    boltM4Buttonhead(12);
                    vflip()
                        washer(M4_washer);
                }
        }

    xExtrusionLength = (floor(heatedBedSize.x/10) + 1)*10;
    translate([-xExtrusionLength/2, yExtrusionLength - scsSize.x/2, 0])
        difference() {
            extrusionOX(xExtrusionLength, eSize);
            separation = xs[0] - xs[1];
            for (x = [(xExtrusionLength + separation)/2, (xExtrusionLength - separation)/2])
                translate([x, 0, eSize/2])
                    rotate([-90,0,0])
                        jointBoltHole();
        }
}

module scs_bearing_block_hole_positions_x(type) {
    screw_separation_x = scs_screw_separation_x(type);
    h = scs_hole_offset(type);

    for(x = [-screw_separation_x, screw_separation_x])
        translate([x / 2, -h, scs_screw_separation_z(type)/2])
            rotate([-90, 0, 0])
                children();
}

sideBracketOffsetY = 1;
sideBracketThickness = 6;
module printBed3pointFrameSideBrackets(zRodSeparation, armSize, frameOffsetX) {
    scsSize = scs_size(scs_type);
    fillet = 1;
    sideBracketSize = [sideBracketThickness, scsSize.x + 1 + 2*sideBracketOffsetY, scsSize.z + 1];
    sideBracketBraceSize = [scsSize.z - eSize, 1.5, sideBracketThickness]; // x value of scsSize.z - eSize for full size

    difference() {
        translate([frameOffsetX, -scsSize.x/2, 0]) {
            if (!is_undef(armSize))
                translate([-armSize.x, 0, 0])
                    rounded_cube_xy(armSize + [0, 10, 0], fillet);
            translate([-sideBracketSize.x, -sideBracketOffsetY, eSize - sideBracketSize.z])
                rounded_cube_xy(sideBracketSize, fillet);
            *translate([-sideBracketSize.x, sideBracketSize.y, 0])
                rotate([0, 90, 0])
                    rounded_right_triangle(sideBracketBraceSize.x, sideBracketBraceSize.y, sideBracketBraceSize.z, fillet, center=false, offset=true);
        }
        translate([zRodSeparation/2, 0, eSize - scsSize.z/2 - scs_screw_separation_z(scs_type)])
            rotate(-90)
                scs_bearing_block_hole_positions_x(scs_type)
                    translate_z(-sideBracketThickness)
                        boltHoleM5(sideBracketThickness, horizontal=true, chamfer=5, chamfer_both_ends=false);
    }
    difference() {
        translate([-frameOffsetX, -scsSize.x/2, 0]) {
            if (!is_undef(armSize))
                rounded_cube_xy(armSize + [0, 10, 0], fillet);
            translate([0, -sideBracketOffsetY, eSize - sideBracketSize.z])
                rounded_cube_xy(sideBracketSize, fillet);
            *translate([0, sideBracketSize.y, 0])
                rotate([0, 90, 0])
                    rounded_right_triangle(sideBracketBraceSize.x, sideBracketBraceSize.y, sideBracketBraceSize.z, fillet, center=false, offset=true);
        }
        translate([-zRodSeparation/2, 0, eSize - scsSize.z/2 - scs_screw_separation_z(scs_type)])
            rotate(90)
                scs_bearing_block_hole_positions_x(scs_type)
                    translate_z(-sideBracketThickness)
                        boltHoleM5(sideBracketThickness, horizontal=true, chamfer=5, chamfer_both_ends=false);
    }
}

module Printbed_Frame_hole_positions() {
    scsSize = scs_size(scs_type);
    armSize = [10, (floor(heatedBedSize.y/50) + 1)*50, eSize];
    endPieceSize = [heatedBedSize.x, 10, eSize];

    translate([-endPieceSize.x/2, armSize.y - scsSize.x/2 + (eSize - endPieceSize.y)/2, endPieceSize.z])
        for (x = [ -heatedBedSize.x/2 + heatedBedHoleOffset, heatedBedSize.x/2 - heatedBedHoleOffset] )
            translate([x + endPieceSize.x/2, endPieceSize.y/2, 0])
                children();
    translate([0, armSize.y - heatedBedSize.y + eSize/2 + 2*heatedBedHoleOffset - scsSize.x/2, endPieceSize.z])
        children();
}

module Printbed_Frame_stl() {
    zRodSeparation = _zRodSeparation;
    scsSize = scs_size(scs_type);
    armSize = [10, (floor(heatedBedSize.y/50) + 1)*50, eSize];
    endPieceSize = [heatedBedSize.x, 10, eSize];
    fillet = 1;
    frameOffsetX = zRodSeparation/2  - scsSize.y/2 - 1;

    stl("Printbed_Frame")
        color(pp1_colour)
        vflip() {
            translate([0, armSize.y - scsSize.x/2 + (eSize - endPieceSize.y)/2, 0]) {
                translate([-endPieceSize.x/2, 0, 0])
                    difference() {
                        rounded_cube_xy(endPieceSize, fillet);
                        for (x = [ -heatedBedSize.x/2 + heatedBedHoleOffset, heatedBedSize.x/2 - heatedBedHoleOffset] )
                            translate([x + endPieceSize.x/2, endPieceSize.y/2, 0])
                                boltHoleM3Tap(eSize);
                    }
                for (v = [ [-frameOffsetX, 0, 0, 180], [-frameOffsetX + armSize.x, 0, 0, 270], [frameOffsetX, 0, 0, 270], [frameOffsetX - armSize.x, 0, 0, 180] ])
                    translate_r(v)
                        fillet(5, eSize);
            }

            crossPieceSize = [zRodSeparation - scsSize.y - 2 - armSize.x, 10, 5];
            translate([-crossPieceSize.x/2, armSize.y/2, eSize])
                vflip()
                    zCarriageCrossPiece(crossPieceSize, armSize.x);

            render(convexity=8)
                difference() {
                    union() {
                        printBed3pointFrameSideBrackets(zRodSeparation, armSize, frameOffsetX);
                        linear_extrude(eSize)
                            difference() {
                                union() {
                                    squareSize = [zRodSeparation - 2*scs_hole_offset(scs_type)-2*fillet - 0*armSize.x, 55];
                                    translate([-squareSize.x/2, -scsSize.x/2 - 1, 0]) {
                                        //translate([-fillet, 0])
                                            square(squareSize, center=false);
                                        translate([armSize.x - fillet, squareSize.y])
                                            fillet(5);
                                        translate([squareSize.x - armSize.x + fillet, squareSize.y])
                                            rotate(90)
                                                fillet(5);
                                    }
                                }
                                poly_circle(r=leadnut_od(leadnut)/2);
                                for (a = [0, 90, 180, 270])
                                    rotate(a)
                                        translate([leadnut_hole_pitch(leadnut), 0, leadnut_flange_t(leadnut)])
                                            poly_circle(r = (a==0 || a==180) ? M3_clearance_radius : M3_tap_radius);
                            }
                    }
                    poly_cylinder(r=leadnut_flange_dia(leadnut)/2, h=leadnutInset + 2*eps);
                    translate([0, armSize.y - heatedBedSize.y + eSize/2 + 2*heatedBedHoleOffset - scsSize.x/2, 0])
                        boltHoleM3Tap(eSize);
                    translate([zRodSeparation/2, 0, eSize - scsSize.z/2])
                        rotate(-90)
                            scs_bearing_block_hole_positions_x(scs_type)
                                rotate([180, 0, 180])
                                    boltHoleM3Tap(15, horizontal=true, chamfer_both_ends=false);
                    translate([-zRodSeparation/2, 0, eSize - scsSize.z/2])
                        rotate(90)
                            scs_bearing_block_hole_positions_x(scs_type)
                                rotate([180, 0, 180])
                                    boltHoleM3Tap(15, horizontal=true, chamfer_both_ends=false);
                }
        }
}

module Printbed_Bracket_stl() {
    scsSize = scs_size(scs_type);
    zRodSeparation = _zRodSeparation;
    cubeSize = [zRodSeparation - scsSize.y - 2 - 2*eSize, 55, eSize];
    armSize = [10, (floor(heatedBedSize.y/50) + 1)*50, eSize];
    frameOffsetX = zRodSeparation/2  - scsSize.y/2 - 1;

    stl("Printbed_Bracket")
        color(pp1_colour) {
            render(convexity=8)
                difference() {
                    linear_extrude(cubeSize.z)
                        difference() {
                            translate([-cubeSize.x/2, -21, 0])
                                rounded_square([cubeSize.x, cubeSize.y], 1, center=false);
                            poly_circle(r=leadnut_od(leadnut)/2);
                            for (a = [0, 90, 180, 270])
                                rotate(a)
                                    translate([leadnut_hole_pitch(leadnut), 0, leadnut_flange_t(leadnut)])
                                        poly_circle(r = (a==0 || a==180) ? M3_clearance_radius : M3_tap_radius);
                        }
                    translate_z(-eps)
                        poly_cylinder(r=leadnut_flange_dia(leadnut)/2, h=leadnutInset + 2*eps);
                    translate([0, armSize.y - heatedBedSize.y + eSize/2 + 2*heatedBedHoleOffset - scsSize.x/2, 0])
                        boltHoleM3Tap(eSize);
                }
            *translate_z(-eSize)
                printBed3pointFrameSideBrackets(zRodSeparation, undef, frameOffsetX);
        }
}

module Print_bed_3_point_bed(y=0) {
    scsSize = scs_size(scs_type);
    yExtrusionLength = (floor(heatedBedSize.y/50) + 1)*50;
    translate([0, y + yExtrusionLength - heatedBedSize.y/2 + eSize/2 + heatedBedHoleOffset - scsSize.x/2, eSize]) {
        printBedSize = 120;
        //Heated_Bed();
        explode(10, true)
            corkUnderlay([heatedBedSize.x, heatedBedSize.y, underlayThickness], printBedSize)
                explode(10, true)
                    heatingPad([100, 100, heatingPadThickness])
                        Heated_Bed()
                            explode(10, true)
                                magneticBase(printBedSize, magneticBaseThickness, holeRadius=3);
    }
}

module Print_bed_3_point_hardware(zRodSeparation, leadnutOffset=eSize/2, scsOffset=0) {

    scsScrewSeparationZ = scs_screw_separation_z(scs_type);

    for (i = [ [ zRodSeparation/2, 0, scsOffset + eSize/2, -90],
               [-zRodSeparation/2, 0, scsOffset + eSize/2, 90] ])
    translate_r(i)
        explode([0, 30, 0], true) {
            scs_bearing_block(scs_type);
            scs_bearing_block_hole_positions_x(scs_type) {
                translate_z(scs_block_side_height(scs_type))
                    explode(20, true)
                        boltM3Caphead(screw_longer_than(scs_block_side_height(scs_type) + 10));
                translate([0, scsScrewSeparationZ, 0])
                    vflip()
                        translate_z(sideBracketThickness)
                            explode(25, true)
                                boltM5Countersunk(12);
            }
        }

    translate_z(leadnutOffset)
        //translate_z((eSize + scs_screw_separation_z(scs_type) - scs_size(scs_type).z)/2) {
        translate_z(scsOffset + scsScrewSeparationZ/2) {
            brassColor = "#B5A642";
            explode(-60, true)
                vflip()
                    color(brassColor)
                        leadnut(leadnut);
            for (a = [0, 180])
                rotate(a)
                    translate([leadnut_hole_pitch(leadnut), 0, eSize - leadnutInset])
                        explode(20, true)
                            screw(leadnut_screw(leadnut), 8);
        }
}

module Print_bed_3_point_assembly()
assembly("Print_bed_3_point", big=true) {

    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, -eSize - printBed3pointBaseOffsetZ]) // this moves it to the back face
        rotate(180) {
            //Print_bed_3_point_hardware(scsOffset=-scs_screw_separation_z(scs_type)/2);
            Print_bed_3_point_hardware(_zRodSeparation, leadnutInset, (eSize - scs_size(scs_type).z)/2);
            translate_z((eSize + scs_screw_separation_z(scs_type) - scs_size(scs_type).z)/2) {
                printbed3pointFrame(_zRodSeparation);
                Print_bed_3_point_bed(heatedBedOffsetE1515);
                stl_colour(pp1_colour)
                    Printbed_Bracket_stl();
            }
        }
}

//!1. Bolt the bearing blocks to the sides of the **Printbed_Frame**.
//!2. Insert the leadnut and bolt it to the **Printbed_Frame**.
//
module Print_bed_3_point_printed_Stage_1_assembly()
staged_assembly("Print_bed_3_point_printed_Stage_1", big=true, ngb=true) {

    vflip()
        translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, -eSize - printBed3pointBaseOffsetZ]) // this moves it to the back face
            rotate(180) {
                Print_bed_3_point_hardware(_zRodSeparation, leadnutInset - 2.5, (eSize - scs_size(scs_type).z)/2);
                vflip()
                    stl_colour(pp1_colour)
                        Printbed_Frame_stl();
            }
}

//!1. Prepare the the cork underlay by cutting it to size, making a cutout for the heated bed wiring, and drilling holes
//!for the bolts.
//!2. Attach the magnetic base to the top side of the aluminium tooling plate.
//!3. Attach the heating pad to the bottom side of the tooling plate.
//!4. Place the cork underlay on the **Printbed_Frame** and place the tooling plate on top.
//!5. Secure the tooling plate to the **Printbed_Frame**, using the bolts and O-rings. Note that the O-rings allow bed
//!leveling and help thermally insulate the heated bed from the **Printbed_Frame**.
//!6. Secure the heating pad wiring to the underside of the **Printbed_Frame** using a cable tie.
//
module Print_bed_3_point_printed_assembly()
staged_assembly("Print_bed_3_point_printed", big=true) {
    vflip()
        Print_bed_3_point_printed_Stage_1_assembly();

    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, -eSize - printBed3pointBaseOffsetZ]) // this moves it to the back face
        rotate(180) {
            Print_bed_3_point_bed();
            crossPieceSize = [0, 10, 5];
            armSize = [10, (floor(heatedBedSize.y/50) + 1)*50, eSize];
            translate([0, armSize.y/2 - crossPieceSize.y/2, eSize - crossPieceSize.z/2])
                rotate([180, 0, 90])
                    cable_tie(cable_r=3, thickness=1);
            Printbed_Frame_hole_positions() {
                translate_z(underlayThickness + heatingPadThickness + heatedBedSize.z - 1)
                    explode(40, true)
                        boltM3Countersunk(12);
                oRingThickness = 2;
                explode(10)
                    color("firebrick")
                        translate_z(oRingThickness/2) {
                                O_ring(3, oRingThickness);
                            translate_z(oRingThickness)
                                O_ring(3, oRingThickness);
                            translate_z(2*oRingThickness)
                                O_ring(3, oRingThickness);
                        }
            }
        }
}
