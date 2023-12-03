include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/tube.scad>
use <NopSCADlib/vitamins/box_section.scad>
include <NopSCADlib/vitamins/psus.scad>
use <NopSCADlib/vitamins/sheet.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pillar.scad>

include <../vitamins/pcbs.scad>
include <../vitamins/psus.scad>

include <Foot.scad>
include <LeftAndRightFaces.scad> // for frameLower
include <../Parameters_Main.scad>
//use <../../../MaybeCube/scad/printed/IEC_Housing.scad>
//function iecHousingSize() = [70, 50, 42 + 3];

function pcbOffsetFromBase() = eSizeZ + 2; // to allow clearance for removing SD card
psuType = _psuDescriptor == "ASUS_FSKE_120W" ? ASUS_FSKE_120W_PSU : NG_CB_200W_24V;
psuZOffset = 2.5;

pcbType = BTT_SKR_MINI_E3_V2_0;

//AL3 = [ "AL3", "Aluminium sheet", 3, 1.05*silver, false];
AL3 = [ "AL3", "Aluminium sheet", 3, silver * 1.1, false];
AL12x8x1 =  ["AL12x8x1",  "Aluminium box section 12mm x 8mm x 1mm",     [12, 8],  1, 0.5, silver, undef];


module Base_stl() {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    stl("Base")
        color(pp3_colour) {
            if (psu_screw_hole_radius(psuType))
                psuPosition(psuType)
                    psuSupportPositions(psuType)
                        psuSupport(psuType);
            translate_z(-size.z)
                linear_extrude(size.z)
                    difference() {
                        rounded_square([size.x, size.y], _fillet, center=false);
                        baseCutouts(pcb=_useCNC ? BTT_SKR_MINI_E3_V2_0 : undef);
                    }
        }
}

module Base_Template_stl(pcb=pcbType) {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, 1];

    stl("Base_Template")
        color(pp1_colour) {
            translate_z(-size.z)
                linear_extrude(size.z)
                    difference() {
                        rounded_square([size.x, size.y], 1.5, center=false);
                        baseCutouts(radius=1, pcb=pcb);
                    }
        }
}

module BaseAL_dxf(pcb=pcbType) {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    dxf("BaseAL")
        color(sheet_colour(AL3))
            difference() {
                sheet_2D(AL3, size.x, size.y, 1);
                translate([-size.x/2, -size.y/2])
                    baseCutouts(cnc=true, cf=_useCNC, pcb=pcb);
            }
}

module BaseAL(pcb=pcbType) {
    size = [eX + 2*eSizeX + _backPlateOutset.x, eY + 2*eSizeY + _backPlateOutset.y, _basePlateThickness];

    translate([size.x/2, size.y/2, -size.z/2])
        render_2D_sheet(AL3, w=size.x, d=size.y)
            BaseAL_dxf(pcb);
}

module baseCutouts(cnc=false, cf=false, radius=M3_clearance_radius, pcb=undef) {
    cncSides = cnc ? 0 : undef;
    baseAllHolePositions(cf=cf)
        poly_circle(radius, sides=cncSides);

    if (is_undef(pcb) || pcb==BTT_SKR_MINI_E3_V2_0)
        pcbPosition(BTT_SKR_MINI_E3_V2_0)
            pcb_screw_positions(BTT_SKR_MINI_E3_V2_0)
                if (!(cnc && $i == 4))
                    poly_circle(radius, sides=cncSides);

    if (is_undef(pcb) || pcb==BTT_SKR_E3_TURBO)
        pcb_back_screw_positions(BTT_SKR_E3_TURBO, -30)
            poly_circle(radius, sides=cncSides);

    if (is_undef(pcb) || pcb==BTT_SKR_V1_4_TURBO)
        pcb_back_screw_positions(BTT_SKR_V1_4_TURBO)
            poly_circle(radius, sides=cncSides);

    pcbPosition(RPI3A_plus)
        pcb_screw_positions(RPI3A_plus)
            poly_circle(radius, sides=cncSides);

    *pcbPosition(BTT_RRF_WIFI_V1_0)
        pcb_screw_positions(BTT_RRF_WIFI_V1_0)
            poly_circle(radius, sides=cncSides);

    if (psu_screw_hole_radius(psuType)) {
        psuPosition(psuType)
            psu_screw_positions(psuType, f_bottom)
                poly_circle(M4_tap_radius, sides=cncSides);
    } else {
        psuPosition(psuType) {
            psuSupportHoleSize = [21, - psuHoleInset.y*2]; // 21 wide for battery strap
            psuHolePositions(psuType)
                rounded_square([psuSupportHoleSize.x, radius < M3_clearance_radius? 2 : psuSupportHoleSize.y], 0.5);
            psuBracketHolePositions(psuType)
                poly_circle(M3_tap_radius, sides=cncSides);
        }
    }
}

//!1. Attach the Base_Template to the aluminium sheet and use it to drill out the holes. The base template has 2mm holes
//!marked out for pilot holes. Once you have drilled these re-drill the holes with a 3mm bit. Note that the Base_Template
//!has holes marked for the BTT E3 Mini V2, the BTT E3 Turbo and the BTT STL 1.4 boards - choose the appropriate holes for
//!your board. If you are unable to source an aluminium sheet, it is possible to print and use the Base.stl file, but
//!using and aluminium plate is much preferred.
//!2. Attach the PSU_Supports to the base plate with double sided tape.
//!3. Bolt the PSU_Bracket to the base plate.
//!4. Attach the PSU to the base plate with the velcro straps.
//!5. Cover the top and bottom sides of the box section with thermal paste.
//!6. Attach the box section to the bottom of the control board with electrical tape. The tape serves to keep the box
//!section in place until it is attached to the base plate.
//!7. Using the hex pillars, attach the control board to the base plate.
//
module Base_assembly()
assembly("Base", big=true) {

    //baseAssembly();
    baseAssembly(pcbType, psuType);
    not_on_bom()
        pcbAssembly(RPI3A_plus);
    vitamin(str("pcb(", RPI3A_plus[0], "): ", pcb_name(RPI3A_plus), " (optional)"));
}

//!1. Attach the Base_Template to the aluminium sheet and use it to drill out the holes. The base template has 2mm holes
//!marked out for pilot holes. Once you have drilled these re-drill the holes with a 3mm bit.
//!2. Bolt the **Base_Front_Joiner**, the **Base_Left_Joiner**, the **Base_Right_Joiner** and the L-shaped feet to the
//!base plate.
//!3. Cover the top and bottom sides of the box section with thermal paste.
//!4. Attach the box section to the bottom of the control board with electrical tape. The tape serves to keep the box
//!section in place until it is attached to the base plate.
//!5. Using the hex pillars, attach the control board and the Raspberry Pi to the base plate.
//!6. Bolt the PSU to the base plate.
//
module BaseCF_assembly()
assembly("BaseCF", big=true) {

    //baseAssembly();
    baseAssembly(BTT_SKR_MINI_E3_V2_0, psuType);
    //baseCoverAssembly();
    pcbAssembly(RPI3A_plus);
    translate_z(-eps) {
        stl_colour(pp2_colour)
            baseLeftFeet();
        baseLeftFeet(hardware=true);
        stl_colour(pp2_colour)
            baseRightFeet();
        baseRightFeet(hardware=true);
        }
    explode(10)
        stl_colour(pp2_colour)
            Base_Front_Joiner_stl();
    baseFrontHolePositions(-_basePlateThickness, cf=true)
        vflip()
            boltM3Buttonhead(10);
    rotate([90, 0, 90]) {
        explode([0, 15, 0])
            stl_colour(pp1_colour)
                Base_Left_Joiner_stl();
        lowerChordHolePositions(includeFeet=false)
            rotate([90, 0, 0])
                translate_z(_basePlateThickness)
                    boltM3Buttonhead(10);
    }
    translate([eX + 2*eSizeX, 0, 0])
        rotate([-90, 0, 90]) {
            explode([0, -15, 0])
                stl_colour(pp1_colour)
                    Base_Right_Joiner_stl();
            lowerChordHolePositions(includeFeet=false)
                rotate([-90, 0, 0])
                    translate_z(_basePlateThickness)
                        boltM3Buttonhead(10);
        }
}

module Base_SKR_E3_Turbo_assembly()
assembly("Base_SKR_E3_Turbo", big=true) {

    baseAssembly(BTT_SKR_E3_TURBO, psuType);
}

module Base_SKR_1_4_assembly()
assembly("Base_SKR_1_4", big=true) {

    baseAssembly(BTT_SKR_V1_4_TURBO, psuType);
}

module baseAssembly(pcb=undef, psuType=undef) {
    BaseAL(pcb=pcb);
    if (!_useCNC)
        hidden() Base_stl();
    hidden() Base_Template_stl();

    if (pcb) {
        pcbAssembly(pcb);
    }
    if (psuType)
        if (psu_screw_hole_radius(psuType)) {
            psuPosition(psuType)
                explode(70, true) {
                    psu(psuType);
                    psu_screw_positions(psuType, f_bottom)
                        vflip()
                            translate_z(3)
                                explode(25)
                                    //bolt(psu_screw(psuType), 8);
                                    boltM4Buttonhead(8);
            }
            //translate([eX + 2*eSizeX, 90 + 25, 14 + psu_size(psuType).z + 10]) {
            *translate([eX + 2*eSizeX, 90 + 25, eSizeZ + iec_body_h(IEC_inlet)/2])
                rotate([90, 0, 90])
                    iec(IEC_inlet);
            //iecType = IEC_320_C14_switched_fused_inlet;
            *translate([eX + 2*eSizeX, eY + 2*eSizeY - eSizeY - 5 - iec_body_h(iecType)/2, eSizeZ/2 + iec_pitch(iecType)/2]) {
            //translate([eX + 2*eSizeX, 90 + 25, eSizeZ/2 + iec_pitch(iecType)/2])
                rotate([0, 90, 0]) {
                    iec(iecType);
                    translate([0, -12, 2 + eps])
                        rotate(90)
                            not_on_bom() no_explode()
                                rocker(small_rocker, "red");
                }
            /*translate([-iecHousingSize().z, -iecHousingSize().x/2, -25])
                rotate([90, 0, 90])
                    IEC_Housing_Bevelled_stl();*/
            }
        } else {
            psuPosition(psuType) {
                explode(50)
                    PSU();
                explode(25)
                    psuSupportPositions(psuType)
                        stl_colour(pp1_colour)
                            PSU_Support_stl();
                explode([-20, 0, 25], true) {
                    psuBracketPosition(psuType)
                        stl_colour(pp1_colour)
                            PSU_Bracket_stl();
                    psuBracketHolePositions(psuType)
                        translate_z(6)
                            boltM3Buttonhead(10);
                }
            }
        }
}

baseCoverHeight = 40;
module Base_Cover_stl() {
    size = [eX, 90, 3];

    color(pp1_colour)
        stl("Base_Cover")
            translate([eSizeX, -size.y - _frontPlateCFThickness, 0]) {
                fillet = 1;
                rounded_cube_xy(size, fillet);
                size2 = [size.x, 3, baseCoverHeight];
                rounded_cube_xy(size2, fillet);
            }
}

module baseCoverAssembly() {
    stl_colour(pp1_colour)
        translate_z(baseCoverHeight)
            vflip()
                Base_Cover_stl();
}
// All corners are offset by _baseBoltHoleInset in both the x and y direction so that the feet are symmetrical.

module baseLeftFeet(hardware=false) {
    footHeight = 8;
    for (i = [ [0, 0, -_basePlateThickness - footHeight, 0], [0, eY + 2*eSizeY, -_basePlateThickness - footHeight, 270] ])
        translate([i.x, i.y, i.z])
            rotate(i[3])
                vflip()
                    explode(20, true)
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
                    explode(20, true)
                        if (hardware)
                            Foot_LShaped_8mm_hardware();
                        else
                            Foot_LShaped_8mm_stl();
}

module Base_Left_Joiner_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    stl("Base_Left_Joiner")
        difference() {
            color(pp1_colour)
                frameLower(NEMA_width, left=true, offset=_sidePlateThickness, cf=true);
            lowerSideJoinerHolePositions(_sidePlateThickness, left=true)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            faceConnectorHolePositions()
                rotate([90, 0, 180])
                    boltHoleM3Tap(backBoltLength(), horizontal=true);
    }
}


module Base_Right_Joiner_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    /*mirror([0, 1, 0])
        translate([iecPosition().y, iecPosition().z, 0])
            rotate([180, 0, 90])
                mirror([0, 1, 0])
                    iec(iecType());*/
    stl("Base_Right_Joiner")
        mirror([0, 1, 0])
            difference() {
                color(pp1_colour)
                    frameLower(NEMA_width, left=false, offset=_sidePlateThickness, cf=true);
                translate([iecPosition().y, iecPosition().z, _sidePlateThickness])
                    rotate([180, 0, 90])
                        mirror([0, 1, 0])
                            iec_screw_positions(iecType())
                                vflip()
                                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                lowerSideJoinerHolePositions(_sidePlateThickness, left=false)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                faceConnectorHolePositions()
                    rotate([90, 0, 180])
                        boltHoleM3Tap(backBoltLength(), horizontal=true);
                rotate([90, 90, 0])
                    translate([-eX - 2*eSizeX, 0, -10])
                        pcbPosition(BTT_SKR_MINI_E3_V2_0)
                            pcb_hole_positions(BTT_SKR_MINI_E3_V2_0)
                                boltHoleM3Tap(8, horizontal=true, rotate=90, chamfer_both_ends=false);
            }
}

module Base_Front_Joiner_stl() {
    size = [eX, eSizeY, eSizeZ];
    stl("Base_Front_Joiner")
        difference() {
            translate([eSizeX, _frontPlateCFThickness, 0])
                color(pp2_colour)
                    rounded_cube_xy(size, _fillet);
            baseFrontHolePositions(cf=true)
                boltHoleM3Tap(size.z);
            baseAllCornerHolePositions()
                boltHoleM3Tap(size.z);
            rotate([90, 0, 0])
                frontFaceLowerHolePositions(-size.y - _frontPlateCFThickness)
                    boltHoleM3Tap(size.y, horizontal=true);
        }
}


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

module pcbPosition(pcbType, alignRight=true) {
    pcbSize = pcb_size(pcbType);

    if (pcbType == BTT_SKR_MINI_E3_V2_0) {// || pcbType == BTT_TF_CLOUD_V1_0)
        translate([alignRight ? eX + 2*eSizeX - pcbSize.x/2 - (_useCNC ? 4 : eSizeXBase + 8) : (eX + 2*eSizeX)/2, pcbSize.y/2 + eSizeY + (_useCNC ? 4 : 2), 0])
            if (pcbType == BTT_SKR_MINI_E3_V2_0)
                children();
            else
                translate([pcbSize.x + 1, 25, 0])
                    children();
    } else if (pcbType == BTT_SKR_E3_TURBO) {
        translate([(eX + 2*eSizeX)/2, 40, 0])
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
        translate([42 + pcbSize.y/2, pcbSize.x/2 + eSizeY + 7.25])
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

module pcbAssembly(pcbType, alignRight=true) {

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

        pcbPosition(pcbType, alignRight) {
            explode(50, true) {
                pcb(pcbType);
                // top side screws
                pcb_screw_positions(pcbType)
                    translate_z(pcb_thickness(pcbType))
                        boltM3Caphead(pcbType != BTT_SKR_MINI_E3_V2_0 || ((_useCNC && $i == 4)) ? 6 : 8);
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
                        if (pcbType != BTT_SKR_MINI_E3_V2_0 || !_useCNC || $i != 4) {
                            explode(15)
                                pillar(M3x12_nylon_hex_pillar);
                            translate_z(-_basePlateThickness)
                                vflip()
                                    explode(20, true)
                                        boltM3Caphead(8);
                        }
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
