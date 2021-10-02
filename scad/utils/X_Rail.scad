include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../vitamins/bolts.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module xRailCarriagePosition(carriagePosition, rotate=0) {
    translate([
        carriagePosition.x + yRailOffset(_xyNEMA_width).x,
        carriagePosition.y,
        eZ - yRailSupportThickness()
        ])
        rotate(rotate)
            children();
}

module xRail(carriagePosition, xCarriageType, xRailLength, yCarriageType) {
    assert(is_list(xCarriageType));
    xRailType = carriage_rail(xCarriageType);
    assert(is_list(xRailType));

    translate([eSizeX + eX/2, carriagePosition.y, eZ - yRailSupportThickness() - carriage_height(yCarriageType)]) {
        railOffsetX = yRailOffset(_xyNEMA_width).x;
        tongueOffset = (eX + 2*eSizeX - xRailLength -2*railOffsetX)/2;
        posX = carriagePosition.x - tongueOffset - xRailLength/2;
        rail_assembly(xCarriageType, xRailLength, posX, carriage_end_colour="green", carriage_wiper_colour="red");
        rail_hole_positions(xRailType, xRailLength, screws = 2, both_ends = true)
            translate_z(rail_screw_height(xRailType, M3_cap_screw))
                bolt(rail_screw(xRailType), 10);
    }
}
