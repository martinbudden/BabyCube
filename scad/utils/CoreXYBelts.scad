include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/core_xy.scad>

include <carriageTypes.scad>
include <../Parameters_CoreXY.scad>


module CoreXYBelts(carriagePosition, x_gap=10, show_pulleys=false) {
    assert(is_list(carriagePosition) && len(carriagePosition) == 2);

    coreXY_belts(coreXY_type(),
        carriagePosition = carriagePosition + [coreXYPosBL(_xyNEMA_width).x, 0],
        coreXYPosBL = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)),
        coreXYPosTR = coreXYPosTR(_xyNEMA_width, carriageType(_yCarriageDescriptor)),
        separation = coreXYSeparation(),
        x_gap = x_gap,
        upper_drive_pulley_offset = [0, 0],
        lower_drive_pulley_offset = [0, 0],
        show_pulleys = show_pulleys,
        left_lower = true);
}
