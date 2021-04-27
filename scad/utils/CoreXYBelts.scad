include <../global_defs.scad>

include <NopSCADlib/core.scad>

use <NopSCADlib/utils/core_xy.scad>

use <carriageTypes.scad>
use <../Parameters_CoreXY.scad>

module CoreXYBelts(NEMA_width, carriagePosition, upper_drive_pulley_offset=[0, 0], lower_drive_pulley_offset=[0, 0], x_gap=20, show_pulleys=false, left_lower = true) {
    assert(!is_undef(NEMA_width));

    coreXY_belts(coreXY_type(),
        carriagePosition = carriagePosition + [coreXYPosBL(NEMA_width).x, 0],
        coreXYPosBL = coreXYPosBL(NEMA_width, yCarriageType()),
        coreXYPosTR = coreXYPosTR(NEMA_width, yCarriageType()),
        separation = coreXYSeparation(),
        x_gap = x_gap,
        upper_drive_pulley_offset = upper_drive_pulley_offset,
        lower_drive_pulley_offset = lower_drive_pulley_offset,
        show_pulleys = show_pulleys,
        left_lower = left_lower);
}
