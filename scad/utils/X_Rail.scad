include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../vitamins/bolts.scad>

use <carriageTypes.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>
include <../Parameters_Positions.scad>


module xRailCarriagePosition() {
    translate([
        carriagePosition.x + yRailOffset(_xyNEMA_width).z,
        carriagePosition.y,
        eZ - yRailSupportThickness()
        ])
        children();
}

module xRail(xCarriageType, xRailLength) {
    assert(is_list(xCarriageType));
    xRailType = carriage_rail(xCarriageType);
    assert(is_list(xRailType));

    translate([ eSizeX + eX/2, carriagePosition.y, eZ - yRailSupportThickness() - carriage_height(yCarriageType())]) {
        railOffsetX = yRailOffset(_xyNEMA_width).z;
        tongueOffset = (eX + 2*eSizeX - xRailLength -2*railOffsetX)/2;
        posX = carriagePosition.x - tongueOffset - xRailLength/2;
        rail_assembly(xCarriageType, xRailLength, posX, carriage_end_colour="green", carriage_wiper_colour="red");
        rail_hole_positions(xRailType, xRailLength, screws = 2, both_ends = true)
            translate_z(rail_screw_height(xRailType, M3_cap_screw))
                screw(rail_screw(xRailType), 10);
    }
}
