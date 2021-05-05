include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>

use <carriageTypes.scad>
use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module CoreXYBelts(carriagePosition, x_gap=10, show_pulleys=false) {
    coreXY_belts(coreXY_type(),
        carriagePosition = carriagePosition + [coreXYPosBL(_xyNEMA_width).x, 0],
        coreXYPosBL = coreXYPosBL(_xyNEMA_width, yCarriageType()),
        coreXYPosTR = coreXYPosTR(_xyNEMA_width, yCarriageType()),
        separation = coreXYSeparation(),
        x_gap = x_gap,
        upper_drive_pulley_offset = [0, 0],
        lower_drive_pulley_offset = [0, 0],
        show_pulleys = show_pulleys,
        left_lower = true);
}
