include <../global_defs.scad>

include <../utils/X_Rail.scad>

include <TopFace.scad>
include <XY_MotorMountCF.scad>
use <PrintheadAssemblies.scad>
use <Y_CarriageAssemblies.scad>
include <../utils/CoreXYBelts.scad>

use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


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
assembly("Top_Face_Stage_1", big=true, ngb=true) {

    translate_z(eZ)
        vflip()
            stl_colour(pp3_colour)
                Top_Face_stl();
    topFaceAssembly(NEMA_width(NEMA14_36), t);
}

module Top_Face_NEMA_17_Stage_1_assembly()  pose(a=[55 + 180, 0, 25 + 310])
assembly("Top_Face_NEMA_17_Stage_1", big=true, ngb=true) {

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
assembly("Top_Face_Stage_2", big=true, ngb=true) {

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
assembly("Top_Face_NEMA_17_Stage_2", big=true, ngb=true) {

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


//! 1. Bolt the rails to the **Top_Face**. Ensure that the left rail is parallel with the left edge before fully tightening the
//! bolts on the left side.
//! 2. The bolts on the right side rail should be only loosely tightened - they will be fully tightened when the right rail
//! is aligned when the X axis rail is added.
//! 3. Bolt the **Top_Face_Back_Joiner** to the top face.
//
module Top_Face_CF_Stage_1_assembly()  pose(a=[55 + 180, 0, 25 + 310])
assembly("Top_Face_CF_Stage_1", big=true) {

    translate_z(eZ - _topPlateThickness + eps)
        Top_Face_CF();
    topFaceAssembly(NEMA_width(NEMA14_36), cf=true);

    explode(-20, show_line=false)
        Top_Face_Back_Joiner_stl();
    topFaceBackHolePositions(eZ)
        boltM3Buttonhead(8);
    explode([20, 0, 0], show_line=false) {
        XY_Motor_Mount_Left_CF_assembly();
        XY_Idler_Bracket_Left_assembly();
    }
    xyMotorMountTopHolePositions(left=true, z=eZ)
        boltM3Buttonhead(8);
    xyMotorMountTopHolePositions(left=false, z=eZ)
        boltM3Buttonhead(8);

    explode([-20, 0, 0], show_line=false) {
        XY_Motor_Mount_Right_CF_assembly();
        XY_Idler_Bracket_Right_assembly();
    }
}

//! Attach the left and right **Y_carriages** to the top face rails. Note that the two carriages are not interchangeable
//! so be sure to attach them as per the diagram.
//!
//! The carriages should be attached to the rails before the pulleys are added, since otherwise the bolts are not
//! accessible.  
//! Attach the pulleys to the carriages. Note that the toothless pulleys are on the inside. Note also that there is a
//! washer under each pulley, but not on top of the pulley.
//!
//! Tighten the pulley bolts until the pulleys stop running freely, and then loosen them slightly (approximately 1/16 of a turn)
//! so they run freely.
//
module Top_Face_CF_Stage_2_assembly(t=undef) pose(a=[55 + 180, 0, 25 + 310])
assembly("Top_Face_CF_Stage_2", big=true, ngb=true) {

    explode(15, show_line=false)
        Top_Face_CF_Stage_1_assembly();

    yCarriageLeftAssembly(NEMA_width(NEMA14_36), t);
    yCarriageRightAssembly(NEMA_width(NEMA14_36), t);
}

//!1. Turn the **Top_Face** into its normal orientation.
//!2. Bolt the X-axis linear rail onto the **Y_carriages**.
//!3. Turn the Top_Face upside down again and place it on a flat surface.
//!4. Align the left and right Y-axis linear rails. Do this by pushing the X-axis rail to the rear of the top face and tighten
//!the corresponding bolts (left loose in a previous step) and then push the X-axis rails to the front of the top face,
//!again tightening the corresponding bolts.
//!5. Check that the carriages run smoothly on the Y-axis linear rails.
//
module Top_Face_CF_Stage_3_assembly(t=undef)
assembly("Top_Face_CF_Stage_3", big=true) {

    Top_Face_CF_Stage_2_assembly(t);

    xRail(carriagePosition(t), carriageType(_xCarriageDescriptor), _xRailLength, carriageType(_yCarriageDescriptor));
}

//! Thread the belts as shown and attach to the **X_Carriage_Belt_Side**.
//
module Top_Face_CF_assembly(t=undef)
assembly("Top_Face_CF", big=true) {

    Top_Face_CF_Stage_3_assembly(t);

    explode(250, true)
        CoreXYBelts(carriagePosition());
    explode(100, true)
        printheadBeltSide();
}

module Top_Face_Back_Joiner_stl() {
    size = [80, eSizeY, eSizeZ];
    stl("Top_Face_Back_Joiner");
    color(pp1_colour)
        difference() {
            translate([(eX + 2*eSizeX - size.x) / 2, eY + 2*eSizeY - size.y, eZ - size.z - _topPlateThickness])
                rounded_cube_xy(size, _fillet);
            rotate([90, 0, 0])
                backFaceCFTopHolePositions(-eY - 2*eSizeY)
                    boltHoleM3Tap(size.y, horizontal=true);
            topFaceBackHolePositions(eZ - _topPlateThickness)
                vflip()
                    boltHoleM3Tap(9);
        }
}


/*
// used for debug
module Top_Face_with_Printhead_assembly(t=undef)
assembly("Top_Face_with_Printhead", big=true) {
    Top_Face_with_X_Rail_assembly();

    xRailCarriagePosition(carriagePosition(t))
        rotate(0) {// for debug, to see belts better
            X_Carriage_Front_assembly();
            Printhead_assembly();
            xCarriageTopBolts(carriageType(_xCarriageDescriptor));
        }
}
*/

module topFaceAssembly(NEMA_width, t=undef, cf=false) {
    yCarriageType = carriageType(_yCarriageDescriptor);
    yRailType = carriage_rail(yCarriageType);

    railOffset = yRailOffset(NEMA_width);
    posY = carriagePosition(t).y - _yRailLength/2 - (_fullLengthYRail ? 0 : eSizeY);

    translate(railOffset)
        rotate([180, 0, 90])
            explode(20, true) {
                rail_assembly(yCarriageType, _yRailLength, posY, carriage_end_colour="green", carriage_wiper_colour="red");
                translate_z(cf ? 0.5 : 0) // so screws are not absolutely flush in drawing
                    rail_screws(yRailType, _yRailLength, thickness = 5 + (cf ? _topPlateThickness - 1 : 0), index_screws = cf ? 0 : 1);
                if (cf)
                    rail_hole_positions(yRailType, _yRailLength, 0)
                        translate_z(-_topPlateThickness)
                            vflip()
                                explode(40, true)
                                    nut_and_washer(M3_nut, true);
            }

    translate([eX + 2*eSizeX - railOffset.x, railOffset.y, railOffset.z])
        rotate([180, 0, 90])
            explode(20, true) {
                rail_assembly(yCarriageType, _yRailLength, posY, carriage_end_colour="green", carriage_wiper_colour="red");
                translate_z(cf ? 0.5 : 0) // so screws are not absolutely flush in drawing
                    rail_screws(yRailType, _yRailLength, thickness=5 + (cf ? _topPlateThickness - 1: 0), index_screws=0);
                if (cf)
                    rail_hole_positions(yRailType, _yRailLength, 0)
                        translate_z(-_topPlateThickness)
                            vflip()
                                explode(40, true)
                                    nut_and_washer(M3_nut, true);
            }
    *translate_z(eZ - bb_width(BB608)/2)
        zLeadScrewHolePosition()
            ball_bearing(BB608);

}
