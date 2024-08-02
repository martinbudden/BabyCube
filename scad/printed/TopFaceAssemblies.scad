include <TopFaceJoiners.scad>
include <../utils/X_Rail.scad>

include <TopFace.scad>
include <XY_MotorMountRB.scad>
use <PrintheadAssemblies.scad>
use <Y_CarriageAssemblies.scad>
use <XY_IdlerBracket.scad>
use <TopFaceRail.scad>

use <../config/Parameters_Positions.scad>
include <../utils/CoreXYBelts.scad>


staged_assembly = true; // set this to false for faster builds during development

module staged_assembly(name, big, ngb) {
    if (staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}


module Top_Face_stl() {
    stl("Top_Face")
        color(pp3_colour)
            vflip()
                topFace(NEMA14_36);
}

module Top_Face_NEMA_17_stl() {
    stl("Top_Face_NEMA_17")
        color(pp3_colour)
            vflip()
                topFace(NEMA17_40);
}

module Top_Face_CF_dxf() {
    dxf("Top_Face_CF")
        topFaceCF(NEMA14_36, extraY=_backPlateCFThickness);
}

module Top_Face_CF() {
    extraY = _backPlateCFThickness;
    size = [eX + 2*eSizeX, eY + 2*eSizeY + extraY];
    //insetY = _backPlateThickness - 1;
    insetY = 0;

    translate([size.x/2, size.y/2 + insetY, 0])
        render_2D_sheet(CF3, w=size.x, d=size.y)
            Top_Face_CF_dxf();
}

//! 1. Turn the **Top_Face** upside down and place it on a flat surface.
//! 2. Bolt the rails to the **Top_Face**. Note that the first and last bolts on the left rail are countersunk bolts and act
//! as pilot bolts to ensure the rails are aligned precisely - they should be tightened before all the other bolts on the
//! left side.
//! 3. The bolts on the right side rail should be only loosely tightened - they will be fully tightened when the right rail
//! is aligned when the X axis rail is added.
module Top_Face_Stage_1_assembly(t=undef)  pose(a=[55 + 180, 0, 25 + 310])
staged_assembly("Top_Face_Stage_1", big=true, ngb=true) {

    translate_z(eZ)
        vflip()
            stl_colour(pp3_colour)
                Top_Face_stl();
    topFaceAssembly(NEMA_width(NEMA14_36), t);
}

module Top_Face_NEMA_17_Stage_1_assembly()  pose(a=[55 + 180, 0, 25 + 310])
staged_assembly("Top_Face_NEMA_17_Stage_1", big=true, ngb=true) {

    translate_z(eZ)
        vflip()
            stl_colour(pp3_colour)
                Top_Face_NEMA_17_stl();
    topFaceAssembly(NEMA_width(NEMA17_40));
}

//! Attach the left and right **Y_carriages** to the top face rails. Note that the two carriages are not interchangeable
//! so be sure to attach them as shown in the diagram.
//!
//! The carriages should be attached to the rails before the pulleys are added, since otherwise the bolts are not
//! accessible.  
//! Attach the pulleys to the carriages. Note that the toothless pulleys are on the inside. Note also that there is a
//! washer under each of the upper pulleys, but not on top of those pulleys.
//!
//! Tighten the pulley bolts until the pulleys stop running freely, and then loosen them slightly (approximately 1/16
//! of a turn) so they run freely.
//
module Top_Face_Stage_2_assembly(t=undef) pose(a=[55 + 180, 0, 25 + 310])
staged_assembly("Top_Face_Stage_2", big=true, ngb=true) {

    explode(15, show_line=false)
        Top_Face_Stage_1_assembly(t);

    yCarriageLeftAssembly(NEMA_width(NEMA14_36), t);
    yCarriageRightAssembly(NEMA_width(NEMA14_36), t);
}

//! Attach the left and right **Y_carriages** to the top face rails. Note that the two carriages are not interchangeable
//! so be sure to attach them as per the diagram.
//!
//! The carriages should be attached to the rails before the pulleys are added, since otherwise the bolts are not
//! accessible.  
//! Attach the pulleys to the carriages. Note that the toothless pulleys are on the inside. Note also that there is a
//! washer under each pulley, but not on top of the pulley.
//!
//! Tighten the pulley bolts until the pulleys stop running freely, and then loosen them slightly (approximately 1/16
//! of a turn) so they run freely.
//
module Top_Face_NEMA_17_Stage_2_assembly() pose(a=[55 + 180, 0, 25 + 310])
staged_assembly("Top_Face_NEMA_17_Stage_2", big=true, ngb=true) {

    explode(15, show_line=false)
        Top_Face_NEMA_17_Stage_1_assembly();

    yCarriageLeftAssembly(NEMA_width(NEMA17_40));
    yCarriageRightAssembly(NEMA_width(NEMA17_40));
}

//!1. Turn the **Top_Face** into its normal orientation.
//!2. Bolt the X-axis linear rail onto the Y carriages.
//!3. Turn the Top_Face upside down again and place it on a flat surface.
//!4. Align the left and right Y-axis linear rails. Do this by pushing the X-axis rail to the rear of the **Top_Face** and tighten
//!the corresponding bolts (left loose in a previous step) and then push the X-axis rails to the front of the **Top_Face**,
//!again tightening the corresponding bolts.
//!5. Check that the carriages run smoothly on the Y-axis linear rails.
//
module Top_Face_assembly(t=undef)
assembly("Top_Face", big=true) {

    Top_Face_Stage_2_assembly(t);
    //hidden() Top_Face_NEMA_17_stl();
    //hidden() Y_Carriage_Left_AL_dxf();
    //hidden() Y_Carriage_Right_AL_dxf();

    xRail(carriagePosition(t), carriageType(_xCarriageDescriptor), _xRailLength, carriageType(_yCarriageDescriptor));
}

//!1. Turn the **Top_Face** into its normal orientation.
//!2. Bolt the X-axis linear rail onto the Y carriages.
//!3. Turn the **Top_Face** upside down again and place it on a flat surface.
//!4. Align the left and right Y-axis linear rails. Do this by pushing the X-axis rail to the rear of the **Top_Face** and tighten
//!the corresponding bolts (left loose in a previous step) and then push the X-axis rails to the front of the **Top_Face**, again
//!tightening the corresponding bolts.
//!5. Check that the carriages run smoothly on the Y-axis linear rails.
//
module Top_Face_NEMA_17_assembly(t=undef)
assembly("Top_Face_NEMA_17", big=true) {

    Top_Face_NEMA_17_Stage_2_assembly();

    xRail(carriagePosition(t), carriageType(_xCarriageDescriptor), _xRailLength, carriageType(_yCarriageDescriptor));
}

module topFaceAssembly(NEMA_width, t=undef, nuts=false, cf=false) {
    yCarriageType = carriageType(_yCarriageDescriptor);
    yRailType = carriage_rail(yCarriageType);

    railOffset = yRailOffset(NEMA_width);
    posY = carriagePosition(t).y - railOffset.y;

    for (i = [ railOffset, [eX + 2*eSizeX - railOffset.x, railOffset.y, railOffset.z] ])
        translate(i)
            rotate([180, 0, 90])
                if (cf) {
                    railHolePositions(yRailType, _yRailLength, 2) {
                        translate_z(-_topPlateThickness)
                            if (nuts)
                                vflip()
                                    explode(40, true)
                                        color(grey(80))
                                            nut_and_washer(M3_nut, nyloc=true);
                        translate_z(rail_height(yRailType) - rail_bore_depth(yRailType))
                            explode(30, true)
                                color(grey(70))
                                    boltM3Caphead(10);
                    }
                } else {
                    rail_assembly(yCarriageType, _yRailLength, posY, carriage_end_colour="green", carriage_wiper_colour="red");
                    if ($preview && (is_undef($hide_bolts) || $hide_bolts == false))
                        rail_screws(yRailType, _yRailLength, thickness=5, index_screws=0);
                }
}

//! 1. Bolt the **Top_Face Joiners** to the **Top_Face_CF**.
//! 2. Bolt the **XY_Idler_Bracket** assemblies to the **Top_Face_CF**.
//
module Top_Face_CF_Stage_1_assembly()
staged_assembly("Top_Face_CF_Stage_1", big=true, ngb=true) {

    translate_z(eZ - _topPlateThickness + eps)
        Top_Face_CF();

    translate([-eps, 0, 0])
        rotate([90, 0, 90])
            explode([0, -50, 0], show_line=false)
                stl_colour(pp3_colour)
                    Top_Face_Left_Joiner_stl();
    translate([eX + 2*eSizeX + eps, 0, 0])
        rotate([-90, 0, 90])
            explode([0, 50, 0], show_line=false)
                stl_colour(pp3_colour)
                    Top_Face_Right_Joiner_stl();
    explode(-50, show_line=false)
        stl_colour(pp3_colour)
            Top_Face_Front_Joiner_stl();

    explode(-50, show_line=false)
        XY_Idler_Bracket_Left_assembly();

    explode(-50, show_line=false)
        XY_Idler_Bracket_Right_assembly();

    topFaceSideHolePositions(eZ)
        explode(25, true)
            boltM3Buttonhead(8);
    topFaceFrontHolePositions(eZ, cf=true)
        explode(25, true)
            boltM3Buttonhead(8);
}

//! 1. Bolt the rails to the **Top_Face**. Ensure that the left rail is parallel with the left edge before fully tightening the
//! bolts on the left side.
//! 2. The bolts on the right side rail should be only loosely tightened - they will be fully tightened when the right rail
//! is aligned when the X axis rail is added.
//
module Top_Face_CF_Stage_2_assembly(t=undef) pose(a=[55 + 180, 0, 25 + 310])
staged_assembly("Top_Face_CF_Stage_2", big=true, ngb=true) {

    Top_Face_CF_Stage_1_assembly();

    topFaceAssembly(NEMA_width(NEMA14_36), nuts=false, cf=true);

    railOffset = yRailOffset(NEMA_width(NEMA14_36));
    explode(40, show_line=false)
        for (x = [0, eX + 2*eSizeX - 2*railOffset.x]) 
            translate([x, 0, 0]) {
                rotate([0, -90, 0])
                stl_colour(pp3_colour)
                    Y_Rail_Handle_stl();
                *vflip()
                    stl_colour(pp3_colour)
                        Y_Rail_Connector_stl();
            }

    //yCarriageLeftAssembly(NEMA_width(NEMA14_36), t);
    //yCarriageRightAssembly(NEMA_width(NEMA14_36), t);
    explode(-20, show_line=false)
        Y_Carriage_Left_Rail_assembly(t=t);
    explode(-20, show_line=false)
        Y_Carriage_Right_Rail_assembly(t=t);

}

//! 1. Bolt the **XY_Motor_Mount** assemblies to the **Top_Face_CF**.
//
module Top_Face_CF_Stage_3_assembly(t=undef)
staged_assembly("Top_Face_CF_Stage_3", big=true, ngb=true) {

    Top_Face_CF_Stage_2_assembly(t);

    explode(-60, show_line=false)
        XY_Motor_Mount_Left_RB_assembly();
    explode(-60, show_line=false)
        XY_Motor_Mount_Right_RB_assembly();
    xyMotorMountTopHolePositions(left=true, z=eZ)
        explode(20, true)
            boltM3Buttonhead(8);
    xyMotorMountTopHolePositions(left=false, z=eZ)
        explode(20, true)
            boltM3Buttonhead(8);
}

//!1. Turn the **Top_Face** into its normal orientation.
//!2. Bolt the X-axis linear rail onto the **Y_Carriages**.
//!3. Turn the Top_Face upside down again and place it on a flat surface.
//!4. Align the left and right Y-axis linear rails. Do this by pushing the X-axis rail to the rear of the top face and tighten
//!the corresponding bolts (left loose in a previous step) and then push the X-axis rails to the front of the top face,
//!again tightening the corresponding bolts.
//!5. Check that the carriages run smoothly on the Y-axis linear rails.
//
module Top_Face_CF_Stage_4_assembly(t=undef)
staged_assembly("Top_Face_CF_Stage_4", big=true, ngb=true) {

    Top_Face_CF_Stage_3_assembly(t);

    xRail(carriagePosition(t), carriageType(_xCarriageDescriptor), _xRailLength, carriageType(_yCarriageDescriptor));
}

//! Thread the belts as shown and attach to the **X_Carriage_Belt_Side**.
//
module Top_Face_CF_assembly(t=undef)
assembly("Top_Face_CF", big=true) {

    Top_Face_CF_Stage_4_assembly(t);

    explode(250, true, show_line=false)
        CoreXYBelts(carriagePosition());
    explode(100, true, show_line=false)
        printheadBeltSide(halfCarriage=false);
}

module Top_Face_Left_Joiner_stl() {
    stl("Top_Face_Left_Joiner")
        difference() {
            color(pp3_colour)
                topFaceSideJoiner();
            upperSideJoinerHolePositions(_sidePlateThickness, reversedBelts=_useReversedBelts)
                boltHoleM3Tap(topBoltHolderSize().z);
        }
}
module Top_Face_Right_Joiner_stl() {
    stl("Top_Face_Right_Joiner")
        mirror([0, 1, 0])
            difference() {
                color(pp3_colour)
                    topFaceSideJoiner();
                upperSideJoinerHolePositions(_sidePlateThickness, reversedBelts=_useReversedBelts)
                    boltHoleM3Tap(topBoltHolderSize().z);
            }
}

/*
// used for debug
module Top_Face_with_Printhead_assembly(t=undef)
staged_assembly("Top_Face_with_Printhead", big=true) {
    Top_Face_with_X_Rail_assembly();

    xRailCarriagePosition(carriagePosition(t))
        rotate(0) {// for debug, to see belts better
            X_Carriage_Front_assembly();
            Printhead_assembly();
            xCarriageTopBolts(carriageType(_xCarriageDescriptor));
        }
}
*/

