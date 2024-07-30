include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core_xy.scad>

module coreXYR_half(type, size, pos, offset_y = 0, x_gap = 0, plain_idler_offset = [0, 0], drive_pulley_offset = [0, 0], show_pulleys = false, lower_belt = false, hflip = false) { //! Draw one belt of a coreXY setup

    function pulley_or(type) = pulley_od(type) / 2;

    // Set offsets for using a plain pulley in place of the y-carriage toothed pulley.
    // the pulley is moved in the x direction, assuming corresponding adjustment in the y-carriage.
    // The last section of belt is moved in the y direction, assuming corresponding adjustment in the x-carriage.
    beltPitchHeight = belt_pitch_height(coreXY_belt(type));
    toothed_idler_offset = [beltPitchHeight, 0];
    toothed_idler_belt_offset = [0, beltPitchHeight];

    // Start and end points
    start_pos = pos + [ (-size.x + x_gap) / 2, -size.y / 2 - pulley_or(coreXY_plain_idler(type)) - offset_y / 2];
    end_pos   = pos + [ (-size.x - x_gap) / 2, -size.y / 2 + pulley_or(coreXY_toothed_idler(type)) + offset_y / 2];
    //end_pos = start_pos + [ -x_gap, -separation_y ];

    // y-carriage plain pulley
    p0_type = coreXY_plain_idler(type);
    p0 = [ size.x / 2, start_pos.y + pulley_or(p0_type) ];

    // top right plain idler pulley
    p1_type = p0_type;
    p1 = [ size.x / 2, size.y / 2 ];

    // top left plain idler pulley
    p2_type = p0_type;
    p2 = [ -size.x / 2, size.y / 2];

    // bottom left anchor plain idler pulley
    p3_type = p0_type;
    p3 = [ -size.x / 2, -size.y / 2 ];

    // y-carriage toothed pulley
    p4_type = coreXY_toothed_idler(type);
    p4 = [ -size.x / 2 + pulley_or(p4_type) + pulley_or(p3_type), end_pos.y - pulley_or(p4_type) ] + toothed_idler_offset;

    // stepper motor drive pulley
    pd_type = coreXY_drive_pulley(type);
    pd = p2 + drive_pulley_offset;

    // drive pulley plain idler
    pdi_type = p0_type;
    pdi = p2 + plain_idler_offset;

    module show_pulleys(show_pulleys) {// Allows the pulley colour to be set for debugging
        if (is_list(show_pulleys))
            color(show_pulleys)
                children();
        else if (show_pulleys)
            children();
    }

    show_pulleys(show_pulleys) {
        translate(p0)
            pulley_assembly(p0_type); // y-carriage plain pulley
        translate(p1)
            pulley_assembly(p1_type); // top right plain idler pulley
        translate(p2)
            pulley_assembly(p2_type); // right left plain idler pulley
        translate(p3)
            pulley_assembly(p3_type); // bottom left anchor plain idler pulley
        translate(pd)
            hflip()
                pulley_assembly(pd_type); // stepper motor drive pulley
        translate(pdi)
            pulley_assembly(pdi_type); // drive pulley plain idler
        translate(p4)
            pulley_assembly(p4_type); // y-carriage toothed pulley
    }

    path_start = [
        [ start_pos.x, start_pos.y, 0],
        [ p0.x, p0.y, -pulley_or(p0_type) ],
        [ p1.x, p1.y, -pulley_or(p1_type) ],
    ];
    path_end = [
        [ p3.x, p3.y, -pulley_or(p3_type) ],
        [ p4.x - toothed_idler_offset.x + toothed_idler_belt_offset.x, p4.y - toothed_idler_offset.y + toothed_idler_belt_offset.y, pulley_or(p4_type) ], 
        [ end_pos.x + toothed_idler_belt_offset.x, end_pos.y + toothed_idler_belt_offset.y, 0]
    ];
    path_middle = plain_idler_offset.y == 0
    ?
        [
            [ pdi.x, pdi.y, -pulley_or(pdi_type) ],
            [ pd.x, pd.y, pulley_or(pd_type) ],
            [ p2.x, p2.y, -pulley_or(p2_type) ],
        ]
    :
        [
            [ p2.x, p2.y, -pulley_or(p2_type) ],
            [ pd.x, pd.y, pulley_or(pd_type) ],
            [ pdi.x, pdi.y, -pulley_or(pdi_type) ],
        ];

    path = concat(path_start, path_middle, path_end);

    belt(type = coreXY_belt(type),
        points = path,
        open = true,
        belt_colour  = lower_belt ? coreXY_lower_belt_colour(type) : coreXY_upper_belt_colour(type),
        tooth_colour = lower_belt ? coreXY_lower_tooth_colour(type) : coreXY_upper_tooth_colour(type));
}

module coreXYR(type, size, pos, separation, offset_y = 0, x_gap = 0, plain_idler_offset = [0, 0], upper_drive_pulley_offset = [0, 0], lower_drive_pulley_offset = [0, 0], show_pulleys = false, left_lower = false) { //! Wrapper module to draw both belts of a coreXY setup
    translate([size.x / 2 - separation.x / 2, size.y / 2, -separation.z / 2]) {
        // lower belt
        hflip(!left_lower)
            explode(25)
                coreXYR_half(type, size, [size.x - pos.x - separation.x / 2 - (left_lower ? x_gap : 0), pos.y], offset_y, x_gap, plain_idler_offset, [-lower_drive_pulley_offset.x, lower_drive_pulley_offset.y], show_pulleys, lower_belt = true, hflip = true);

        // upper belt
        translate([separation.x, 0, separation.z])
            hflip(left_lower)
                explode(25)
                    coreXYR_half(type, size, [pos.x + separation.x / 2 + (left_lower ? x_gap : 0), pos.y], offset_y, x_gap, plain_idler_offset, upper_drive_pulley_offset, show_pulleys, lower_belt = false, hflip = false);
    }
}

module coreXYR_belts(type, carriagePosition, coreXYPosBL, coreXYPosTR, separation, offset_y = 0, x_gap = 0, plain_idler_offset = [0, 0], upper_drive_pulley_offset = [0, 0], lower_drive_pulley_offset = [0, 0], show_pulleys = false, left_lower = false) { //! Draw the coreXY belts
    assert(coreXYPosBL.z == coreXYPosTR.z);
    assert(plain_idler_offset.x !=0 || plain_idler_offset.y != 0);

    coreXYSize = coreXYPosTR - coreXYPosBL;
    translate(coreXYPosBL)
        coreXYR(type, coreXYSize, [carriagePosition.x - coreXYPosBL.x, carriagePosition.y - coreXYPosBL.y], separation, offset_y, x_gap, plain_idler_offset, upper_drive_pulley_offset, lower_drive_pulley_offset, show_pulleys, left_lower);
}
