include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/tube.scad>
use <NopSCADlib/vitamins/box_section.scad>
include <NopSCADlib/vitamins/psus.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pillar.scad>

include <../vitamins/pcbs.scad>
include <../vitamins/psus.scad>

include <../config/Parameters_Main.scad>

function pcbOffsetFromBase() = eSizeZ + 2; // to allow clearance for removing SD card
psuType = _psuDescriptor == "ASUS_FSKE_120W" ? ASUS_FSKE_120W_PSU : NG_CB_200W_24V;
psuZOffset = 2.5;

pcbType = BTT_SKR_MINI_E3_V2_0;
AL12x8x1 =  ["AL12x8x1",  "Aluminium box section 12mm x 8mm x 1mm",     [12, 8],  1, 0.5, silver, undef];

//psuSize = [130, 58, 30];
//psuSize = [169, 65, 39];
psuHoleInset = [36, -1.25];

module psuPosition(psuType) {
    psuSize = psu_size(psuType);
    // [125.5, 121.5, 0];
    //echo(p=[eX + 2*eSizeX - eSizeXBase - psuSize.x/2, eY + 2*eSizeY - psuSize.y/2 - 46, 0]);
    if (psu_screw_hole_radius(psuType))
        //translate([eX + 2*eSizeX - psuSize.x/2 - eSizeXBase, 90 + psuSize.y/2, 0])
        translate([eX + 2*eSizeX - psuSize.x/2 - 15, 90 + psuSize.y/2, 0])
            children();
    else
        translate([eX + 2*eSizeX - eSizeXBase - psuSize.x/2, eY + 2*eSizeY - psuSize.y/2 - 46, 0])
            children();
}

module psuHolePositions(psuType) {
    psuSize = psu_size(psuType);
    for (x = [psuSize.x/2 - psuHoleInset.x + 1, -psuSize.x/2 + psuHoleInset.x],
         y = [psuSize.y/2 - psuHoleInset.y, -psuSize.y/2 + psuHoleInset.y]
        )
    translate([x, y, 0])
        children();
}

module psuSupportPositions(psuType) {
    psuSize = psu_size(psuType);
    for (x = [psuSize.x/2 - psuHoleInset.x + 1, -psuSize.x/2 + psuHoleInset.x],
         y = [0]
        )
    translate([x, y])
        children();
}

module psuBracketPosition(psuType) {
    psuSize = psu_size(psuType);
    translate([-psuSize.x/2 - 10, 0])
        children();
}

module psuBracketHolePositions(psuType) {
    psuBracketPosition(psuType)
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
            psuSupport(psuType);
}

module psuSupport(psuType) {
    psuSize = psu_size(psuType);
    rounded_cube_xy([20, psuSize.y, psuZOffset], 1, xy_center=true);
}

module PSU() {
    psuSize = psu_size(psuType);
    translate_z(psuZOffset) {// to allow wires to run underneath PSU
        color(grey(30))
            difference() {
                rounded_cube_xy(psuSize, 3, xy_center=true);
                hull()
                    translate([psuSize.x/2 - 5 + 2*eps, 0, psuSize.z/2])
                        rotate([90, 0, 90])
                            not_on_bom() iec(IEC_inlet);
            }
        translate([psuSize.x/2 - 5, 0, psuSize.z/2])
            rotate([90, 0, 90])
                not_on_bom() iec(IEC_inlet);
    }
}

module pcbPosition(pcbType, alignRight=true, cnc=_useCNC) {
    pcbSize = pcb_size(pcbType);

    if (pcbType == BTT_SKR_MINI_E3_V2_0) {// || pcbType == BTT_TF_CLOUD_V1_0)
        translate([alignRight ? eX + 2*eSizeX - pcbSize.x/2 - eSizeXBase - (cnc ? 18 : 8) : (eX + 2*eSizeX)/2, pcbSize.y/2 + eSizeY + (cnc ? 4 : 2), 0])
            if (pcbType == BTT_SKR_MINI_E3_V2_0)
                children();
            else
                translate([pcbSize.x + 1, 25, 0])
                    children();
    } else if (pcbType == BTT_SKR_E3_TURBO) {
        translate([(eX + 2*eSizeX)/2, 40, 0])
            children();
    } else if (pcbType == BTT_SKR_PICO_V1_0) {
        translate([(eX + 2*eSizeX)/2 + 35, 50, 0])
            children();
    } else if (pcbType == BTT_SKR_V1_4_TURBO) {// || pcbType == BTT_RRF_WIFI_V1_0)
        translate([(eX + 2*eSizeX)/2, pcbSize.y/2 + 1, 0]) // y offset of 1 allows front lower chord to be filled in for headless mode
            if (pcbType == BTT_SKR_V1_4_TURBO)
                children();
            else
                translate([pcbSize.x/2 + pcbSize.y/2 + 1, 0, 0])
                    rotate(90)
                        children();
    } else if (pcbType == RPI0) {
        translate([40 + 26 + pcbSize.y/2, pcbSize.x/2 + eSizeY + 2])
        //translate([eX + 2*eSizeX - eSizeXBase - 10 - pcbSize.y/2, pcbSize.x/2 + eSizeY + 5])
            rotate(-90)
                children();
    } else if (pcbType == RPI3) {
        translate([40 + pcbSize.y/2, pcbSize.x/2 + eSizeY + 2])
            rotate(90)
                children();
    } else if (pcbType == RPI3A_plus) {
        translate([(cnc ? 32 : 42) + pcbSize.y/2, pcbSize.x/2 + eSizeY + 7.25])
            rotate(-90)
                children();
    } else if (pcbType == RPI4) {
        translate([eX + 2*eSizeX - eSizeXBase - pcbSize.y/2, pcbSize.x/2 + eSizeY + 5])
            rotate(90)
                children();
    }
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

module pcb_back_screw_positions(type, yCutoff=0) {
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

M3x10_nylon_hex_pillar = ["M3x10_nylon_hex_pillar", "hex nylon", 3, 10, 6/cos(30), 6/cos(30),  6, 6,  grey(20),   grey(20),  -5, -5 + eps];
M3x12_nylon_hex_pillar = ["M3x12_nylon_hex_pillar", "hex nylon", 3, 12, 6/cos(30), 6/cos(30),  6, 6,  grey(20),   grey(20),  -6, -6 + eps];

module pcbAssembly(pcbType, alignRight=true, cnc=_useCNC) {

    if (is_undef($hide_pcb) || $hide_pcb == false)
    translate_z(pcbOffsetFromBase()) {
        /*pcbPosition(BTT_SKR_V1_4_TURBO)
            pcb(BTT_SKR_V1_4_TURBO);
        pcbPosition(BTT_SKR_MINI_E3_V2_0)
            pcb(BTT_SKR_MINI_E3_V2_0);*/

        *if (pcbType == BTT_SKR_V1_4_TURBO)
            pcbPosition(BTT_RRF_WIFI_V1_0)
                pcb(BTT_RRF_WIFI_V1_0);

        //pcbPosition(RPI4)
        //    pcb(RPI4);

        pcbPosition(pcbType, alignRight, cnc) {
            explode(50, true) {
                pcb(pcbType);
                // top side screws
                pcb_screw_positions(pcbType)
                    translate_z(pcb_thickness(pcbType))
                        //boltM3Caphead(pcbType != BTT_SKR_MINI_E3_V2_0 || ((cnc && $i == 4)) ? 6 : 8);
                        boltM3Caphead(8);
            }
            if (pcbType == BTT_SKR_V1_4_TURBO) {
                pcb_back_screw_positions(pcbType)
                    translate_z(-pcbOffsetFromBase()) {
                        pillar(M3x12_nylon_hex_pillar);
                        translate_z(-_basePlateThickness)
                            vflip()
                                boltM3Caphead(8);
                    }
            } else {
                // bottom side screws and pillars
                translate_z(-pcbOffsetFromBase())
                    pcb_screw_positions(pcbType) {
                        //if (pcbType != BTT_SKR_MINI_E3_V2_0 || !cnc || $i != 4) {
                            explode(15)
                                pillar(M3x12_nylon_hex_pillar);
                            translate_z(-_basePlateThickness)
                                vflip()
                                    explode(30, true)
                                        boltM3Caphead(8);
                        //}
                    }
                if (pcbType == BTT_SKR_MINI_E3_V2_0 || pcbType == BTT_SKR_E3_TURBO) {
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
}
