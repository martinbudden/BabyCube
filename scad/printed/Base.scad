include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/tube.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pillar.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/iecs.scad>

use <../utils/HolePositions.scad>

use <../vitamins/bolts.scad>

use <Foot.scad>
include <../Parameters_Main.scad>


function pcbOffsetFromBase() = eSizeZ + 2;
psuZOffset = 2.5;

AL3 = [ "AL3", "Aluminium sheet", 3, silver, false];


module Base_stl() {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    stl("Base")
        color(pp3_colour) {
            psuPosition()
                psuSupportPositions()
                    psuSupport(psuZOffset);
            translate_z(-size.z)
                linear_extrude(size.z)
                    difference() {
                        rounded_square([size.x, size.y], _fillet, center = false);
                        baseCutouts();
                    }
        }
}

module Base_Template_stl() {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, 1];

    stl("Base_Template")
        color(pp1_colour) {
            translate_z(-size.z)
                linear_extrude(size.z)
                    difference() {
                        rounded_square([size.x, size.y], 1.5, center = false);
                        baseCutouts(radius=1);
                    }
        }
}

module BaseAL_dxf() {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    dxf("BaseAL")
        color(silver)
            difference() {
                sheet_2D(AL3, size.x, size.y, 1);
                translate([-size.x/2, -size.y/2])
                    baseCutouts(cncSides=0);
            }
}

module BaseAL() {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    translate([size.x/2, size.y/2, -size.z/2])
        render_2D_sheet(AL3, w=size.x, d=size.y)
            BaseAL_dxf();
}

module baseCutouts(cncSides = undef, radius=M3_clearance_radius) {
    baseAllHolePositions()
        poly_circle(radius, sides=cncSides);

    // add bolt holes for both SKR_MINI_E3 and SKR_V1_4_TURBO
    pcbPosition(BTT_SKR_MINI_E3_V2_0)
        pcb_screw_positions(BTT_SKR_MINI_E3_V2_0)
            poly_circle(radius, sides=cncSides);
    pcbPosition(BTT_SKR_E3_TURBO)
        pcb_back_screw_positions(BTT_SKR_E3_TURBO, -30)
            poly_circle(radius, sides=cncSides);

    pcbPosition(BTT_SKR_V1_4_TURBO)
        pcb_back_screw_positions(BTT_SKR_V1_4_TURBO)
            poly_circle(radius, sides=cncSides);

    pcbPosition(RPI0)
        pcb_screw_positions(RPI0)
            poly_circle(radius, sides=cncSides);

    *pcbPosition(BTT_RRF_WIFI_V1_0)
        pcb_screw_positions(BTT_RRF_WIFI_V1_0)
            poly_circle(radius, sides=cncSides);

    psuPosition() {
        psuHolePositions()
            rounded_square([psuSupportHoleSize.x, radius < M3_clearance_radius? 2 : psuSupportHoleSize.y], 0.5);
        psuBracketHolePositions()
            poly_circle(M3_tap_radius, sides=cncSides);
    }
}

//!1. Attach the Base_Template to the aluminium sheet and use it to drill out the holes. The base template has 2mm holes marked out for a pilot hole.
//!Once you have drilled these re-drill the holes with a 3mm bit. Note that the Base_Template has holes marked for the BTT E3 Mini V2, the BTT E3 Turbo and the BTT STL 1.4 boards - choose the appropriate holes for your board.
//!2. Attach the PSU_Supports to the base plate with double sided tape.
//!3. Bolt the PSU_Bracket to the base plate.
//!4. Attach the PSU to the base plate with the velcro straps.
//!5. Cover the top and bottom sides of the box section with thermal paste.
//!6. Attach the box section to the bottom of the control board with electrical tape. The tape serves to keep the box section in place until it is attached to the base plate.
//!7. Using the hex pillars, attach the control board to the base plate.
//
module Base_assembly()
assembly("Base", big=true) {

    pcbAssembly(BTT_SKR_MINI_E3_V2_0);
    baseAssembly();
}

module Base_SKR_E3_Turbo_assembly()
assembly("Base_SKR_E3_Turbo", big=true) {

    pcbAssembly(BTT_SKR_E3_TURBO);
    baseAssembly();
}

module Base_SKR_1_4_assembly()
assembly("Base_SKR_1_4", big=true) {

    pcbAssembly(BTT_SKR_V1_4_TURBO);
    baseAssembly();
}

module baseAssembly() {
    BaseAL();
    hidden() Base_stl();
    hidden() Base_Template_stl();

    psuPosition() {
        explode(50)
            translate_z(psuZOffset) // to allow wires to run underneath PSU
                PSU();
        explode(25)
            psuSupportPositions()
                stl_colour(pp1_colour)
                    PSU_Support_stl();
        explode([-20, 0, 25], true) {
            psuBracketPosition()
                stl_colour(pp1_colour)
                    PSU_Bracket_stl();
            psuBracketHolePositions()
                translate_z(6)
                    boltM3Buttonhead(10);
        }
    }
}


// All corners are offset by _baseBoltHoleInset in both the x and y direction so that the feet are symmetrical.

module baseLeftFeet(hardware=false) {
    footHeight = 8;
    for (i = [ [0, 0, -_basePlateThickness - footHeight, 0], [0, eY+2*eSizeY, -_basePlateThickness - footHeight, 270] ])
        translate([i.x, i.y, i.z])
            rotate(i[3])
                vflip()
                    if (hardware)
                        Foot_LShaped_8mm_hardware();
                    else
                        Foot_LShaped_8mm_stl();
    }

module baseRightFeet(hardware=false) {
    footHeight = 8;
    for (i = [ [eX + 2*eSizeX, 0, -_basePlateThickness - footHeight, 90], [eX + 2*eSizeX, eY + 2*eSizeY, -_basePlateThickness - footHeight, 180] ])
        translate([i.x, i.y, i.z])
            rotate(i[3])
                vflip()
                    if (hardware)
                        Foot_LShaped_8mm_hardware();
                    else
                        Foot_LShaped_8mm_stl();
}

//psuSize = [130, 58, 30];
psuSize = [169, 65, 39];
psuHoleInset = [36, -1.25];
psuSupportHoleSize = [21, -psuHoleInset.y*2]; // 21 wide for battery strap

module psuPosition() {
    translate([eX + 2*eSizeX - eSizeXBase - psuSize.x/2, eY + 2*eSizeY - psuSize.y/2 - 46, 0])
        children();
}

module psuHolePositions() {
    for (x = [psuSize.x/2 - psuHoleInset.x + 1, -psuSize.x/2 + psuHoleInset.x],
         y = [psuSize.y/2 - psuHoleInset.y, -psuSize.y/2 + psuHoleInset.y]
        )
    translate([x, y])
        children();
}

module psuSupportPositions() {
    for (x = [psuSize.x/2 - psuHoleInset.x + 1, -psuSize.x/2 + psuHoleInset.x],
         y = [0]
        )
    translate([x, y])
        children();
}

module psuBracketPosition() {
    translate([-psuSize.x/2 - 10, 0])
        children();
}

module psuBracketHolePositions() {
    psuBracketPosition()
        for (y = [10, -10])
            translate([0, y])
                children();
}

module PSU_Bracket_stl() {
    stl("PSU_Bracket")
        color(pp1_colour) {
            size = [20, 40, 6];
            linear_extrude(size.z)
                difference() {
                    rounded_square([size.x, size.y], 2);
                    for (y = [-10, 10])
                        translate([-3, y])
                            hull() {
                                circle(r=M3_clearance_radius);
                                translate([5, 0])
                                    circle(r=M3_clearance_radius);
                            }
                }
            tabSize = [5, (size.y - 15)/2, 15];
            for (y = [ size.y/2 - tabSize.y, -size.y/2])
                translate([size.x/2 - 5, y, 0])
                    rounded_cube_xy(tabSize, 2);
        }
}

module PSU_Support_stl() {
    stl("PSU_Support")
        color(pp1_colour)
            psuSupport(psuZOffset);
}

module psuSupport(sizeZ) {
    linear_extrude(sizeZ)
        difference() {
            size = [20, psuSize.y];
            rounded_square(size, 1, center=true);
            /*for (y = [psuSize.y/2 - psuHoleInset.y, -psuSize.y/2 + psuHoleInset.y])
                translate([0, y])
                    rounded_square(psuSupportHoleSize, 0.5);*/
            /*tSize = 3.5;
            translate([-size.x/2 + tSize, -size.y/2])
                right_triangle(tSize -1, tSize);
            translate([-size.x/2, -size.y/2])
                square([tSize, tSize]);
            translate([-size.x/2, -size.y/2 + tSize])
                fillet(1);*/
        }
}

module PSU() {
    color(grey(30))
        difference() {
            rounded_cube_xy(psuSize, 3, xy_center = true);
            hull()
                translate([psuSize.x/2 - 5 + 2*eps, 0, psuSize.z/2])
                    rotate([90, 0, 90])
                        not_on_bom() iec(IEC_inlet);
        }

    translate([psuSize.x/2 - 5, 0, psuSize.z/2])
        rotate([90, 0, 90])
            not_on_bom() iec(IEC_inlet);
}

module pcbPosition(pcbType, alignRight = false) {
    pcbSize = pcb_size(pcbType);
    skrMiniE3PcbSize = pcb_size(BTT_SKR_MINI_E3_V2_0);
    skrE3TurboPcbSize = pcb_size(BTT_SKR_E3_TURBO);
    raspberryPi0PcbSize = pcb_size(RPI0);
    raspberryPi4PcbSize = pcb_size(RPI4);
    skrV1_4Size = pcb_size(BTT_SKR_V1_4_TURBO);

    if (pcbType == BTT_SKR_MINI_E3_V2_0) // || pcbType == BTT_TF_CLOUD_V1_0)
        translate([alignRight ? eX + 2*eSizeX - skrMiniE3PcbSize.x/2 - eSizeXBase - 2 : (eX + 2*eSizeX)/2, skrMiniE3PcbSize.y/2 + eSizeY + 1, 0])
            if (pcbType == BTT_SKR_MINI_E3_V2_0)
                children();
            else
                translate([skrMiniE3PcbSize.x/2 + pcbSize.x/2 + 1, 25, 0])
                    children();
    else if (pcbType == BTT_SKR_V1_4_TURBO) // || pcbType == BTT_RRF_WIFI_V1_0)
        translate([(eX + 2*eSizeX)/2, skrV1_4Size.y/2 + 1, 0]) // y offset of 1 allows front lower chord to be filled in for headless mode
            if (pcbType == BTT_SKR_V1_4_TURBO)
                children();
            else
                translate([skrV1_4Size.x/2 + pcbSize.y/2 + 1, 0, 0])
                    rotate(90)
                        children();
    else if (pcbType == BTT_SKR_E3_TURBO)
        translate([(eX + 2*eSizeX)/2, 40, 0])
            children();
    else if (pcbType == RPI0)
        translate([eX + 2*eSizeX - eSizeXBase - 10 - raspberryPi0PcbSize.y/2, raspberryPi0PcbSize.x/2 + eSizeY + 5])
            rotate(90)
                children();
    else if (pcbType == RPI4)
        translate([eX + 2*eSizeX - eSizeXBase - raspberryPi4PcbSize.y/2, raspberryPi4PcbSize.x/2 + eSizeY + 5])
            rotate(90)
                children();
}

module pcb_front_screw_positions(type) {
    holes = pcb_holes(type);

    for ($i = [0 : 1 : len(holes) - 1]) {
        hole = holes[$i];
        if (len(hole) == 2 || all) {
            pos = pcb_coord(type, hole);
            if (pos.y < 0)
                translate(pos)
                    children();
        }
   }
}

module pcb_back_screw_positions(type, yCutoff = 0) {
    holes = pcb_holes(type);

    for ($i = [0 : 1 : len(holes) - 1]) {
        hole = holes[$i];
        if (len(hole) == 2 || all) {
            pos = pcb_coord(type, hole);
            if (pos.y > yCutoff)
                translate(pos)
                    children();
        }
   }
}

AL12x8x1 =  ["AL12x8x1",  "Aluminium box section 12mm x 8mm x 1mm",     [12, 8],  1, 0.5, silver, undef];
AL20x20x2 = ["AL20x20x2", "Aluminium box section 20mm x 20mm x 2mm",    [20, 20], 2, 0.5, silver, undef];
CF12x8x1 =  ["CF10x10x1", "Carbon fiber box section 10mm x 10mm x 1mm", [10, 10], 1, 0.5, grey(35), grey(20)];

function box_section_material(type)  = type[1]; //! Material description
function box_section_size(type)      = type[2]; //! Size
function box_section_thickness(type) = type[3]; //! Thickness
function box_section_fillet(type)    = type[4]; //! Fillet
function box_section_colour(type)    = type[5]; //! Colour
function box_section_colour2(type)   = type[6]; //! Colour2, for woven box section
function box_section_is_woven(type)  = !is_undef(type[6]); //! Box section is woven, eg carbon fiber

module box_section(type, length, center = true) {
    vitamin(str("box_section(", type[0], arg(length, 15), "): ", box_section_material(type), ", length ", length, "mm"));

    size = box_section_size(type);
    thickness = box_section_thickness(type);

    if (box_section_is_woven(type))
        translate_z(center ? 0 : length / 2) {
            rotate([0, -90, 90])
                for (z = [-size.y / 2, size.y / 2 - thickness])
                    translate_z(z)
                        woven_sheet(CF1, thickness, box_section_colour(type), box_section_colour2(type), length, size.x)
                            square([length, size.x], center=true);
            rotate([0, -90, 0])
                for (z = [-size.x / 2, size.x / 2 - thickness])
                    translate_z(z)
                        woven_sheet(CF1, thickness, box_section_colour(type), box_section_colour2(type), length, size.y)
                            square([length, size.y], center=true);
        }
    else
        color(box_section_colour(type))
            rectangular_tube([size.x, size.y, length], center, thickness, box_section_fillet(type));
}

M3x10_nylon_hex_pillar = ["M3x10_nylon_hex_pillar", "hex nylon", 3, 10, 6/cos(30), 6/cos(30),  6, 6,  grey(20),   grey(20),  -5, -5+eps];
M3x12_nylon_hex_pillar = ["M3x12_nylon_hex_pillar", "hex nylon", 3, 12, 6/cos(30), 6/cos(30),  6, 6,  grey(20),   grey(20),  -6, -6+eps];

module pcbAssembly(pcbType, alignRight = false) {

    if (is_undef($hide_pcb) || $hide_pcb == false)
    translate_z(pcbOffsetFromBase()) {
        /*pcbPosition(BTT_SKR_V1_4_TURBO)
            pcb(BTT_SKR_V1_4_TURBO);
        pcbPosition(BTT_SKR_MINI_E3_V2_0)
            pcb(BTT_SKR_MINI_E3_V2_0);*/

        *if (pcbType == BTT_SKR_V1_4_TURBO)
            pcbPosition(BTT_RRF_WIFI_V1_0)
                pcb(BTT_RRF_WIFI_V1_0);

        *if (pcbType == BTT_SKR_MINI_E3_V2_0)
            pcbPosition(BTT_TF_CLOUD_V1_0, alignRight)
                pcb(BTT_TF_CLOUD_V1_0);

        *pcbPosition(RPI0)
            pcb(RPI0);
        //pcbPosition(RPI4)
        //    pcb(RPI4);

        pcbPosition(pcbType, alignRight) {
            explode(20, true) {
                pcb(pcbType);
                pcb_screw_positions(pcbType)
                    translate_z(pcb_thickness(pcbType))
                        boltM3Caphead(6);
            }
            if (pcbType == BTT_SKR_V1_4_TURBO) {
                pcb_back_screw_positions(pcbType)
                    translate_z(-pcbOffsetFromBase()) {
                        pillar(M3x12_nylon_hex_pillar);
                        translate_z(-_basePlateThickness)
                            vflip()
                                boltM3Caphead(8);
                    }
            } else if (pcbType == BTT_SKR_MINI_E3_V2_0 || pcbType == BTT_SKR_E3_TURBO) {
                pcb_screw_positions(pcbType) {
                    translate_z(-pcbOffsetFromBase()) {
                        explode(10)
                            pillar(M3x12_nylon_hex_pillar);
                        translate_z(-_basePlateThickness)
                            vflip()
                                explode(20, true)
                                    boltM3Caphead(8);
                    }
                }
                tubeHeight = 12;
                explode(10)
                    translate_z(-tubeHeight/2) {
                        translate(pcb_component_position(pcbType, "-block"))
                            rotate([0, 90, 0])
                                box_section(AL12x8x1, 85);
                /*tubeLength = 25;
                explode(10)
                    translate([-5 + tubeLength/2, 5 - tubeSize/2, 0])
                        translate(pcb_component_position(pcbType, "-block", 1))
                            rotate([0, -90, 0])
                                box_section(AL12x12x1, tubeLength);*/
                }
            }
        }
    }
}
