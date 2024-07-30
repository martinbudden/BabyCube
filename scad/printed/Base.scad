include <BaseJoiners.scad>
include <BasePSUandPCBs.scad>

use <NopSCADlib/vitamins/sheet.scad>

include <Foot.scad>


AL3 = [ "AL3", "Aluminium sheet", 3, silver * 1.1, false];


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
    baseAllHolePositions(cf=cf, coverHolePosY=baceCoverCenterHolePosY)
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

//!1. Attach the **Base_Template** to the aluminium sheet and use it to drill out the holes. The base template has 2mm holes
//!marked out for pilot holes. Once you have drilled these re-drill the holes with a 3mm bit. Note that the **Base_Template**
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
//
module Base_CF_Stage_1_assembly()
assembly("Base_CF_Stage_1", big=true) {
    BaseAL(pcb=pcbType);
    if (!_useCNC)
        hidden() Base_stl();
    hidden() Base_Template_stl();


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
            explode(15, true)
                boltM3Buttonhead(10);
    rotate([90, 0, 90]) {
        explode([0, 25, 0])
            stl_colour(pp1_colour)
                Base_Left_Joiner_stl();
        lowerChordHolePositions(includeFeet=false)
            rotate([90, 0, 0])
                translate_z(_basePlateThickness)
                    explode(15, true)
                        boltM3Buttonhead(10);
    }
    translate([eX + 2*eSizeX, 0, 0])
        rotate([-90, 0, 90]) {
            explode([0, -25, 0])
                stl_colour(pp1_colour)
                    Base_Right_Joiner_stl();
            lowerChordHolePositions(includeFeet=false)
                rotate([-90, 0, 0])
                    translate_z(_basePlateThickness)
                        explode(15, true)
                            boltM3Buttonhead(10);
        }
}

//!1. Cover the top and bottom sides of the box section with thermal paste.
//!2. Attach the box section to the bottom of the control board with electrical tape. The tape serves to keep the box
//!section in place until it is attached to the base plate.
//!3. Using the hex pillars, attach the control board and the Raspberry Pi to the base plate.
//!4. Bolt the PSU to the base plate.
//
module Base_CF_assembly()
assembly("Base_CF", big=true) {

    Base_CF_Stage_1_assembly();

    //baseAssembly();
    baseAssembly(BTT_SKR_MINI_E3_V2_0, psuType);
    pcbAssembly(RPI3A_plus);
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

// All corners are offset by _baseBoltHoleInset in both the x and y direction so that the feet are symmetrical.
module baseLeftFeet(hardware=false) {
    footHeight = 8;
    for (i = [ [0, 0, -_basePlateThickness - footHeight, 0], [0, eY + 2*eSizeY, -_basePlateThickness - footHeight, 270] ])
        translate([i.x, i.y, i.z])
            rotate(i[3])
                vflip()
                    explode(hardware ? 30 : 20, true)
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
                    explode(hardware ? 30 : 20, true)
                        if (hardware)
                            Foot_LShaped_8mm_hardware();
                        else
                            Foot_LShaped_8mm_stl();
}

