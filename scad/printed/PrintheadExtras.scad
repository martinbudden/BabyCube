include <../config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

include <../utils/bezierTube.scad>
include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/HolePositions.scad>
include <../vitamins/cables.scad>
use <../vitamins/extruder.scad> // for extruderBowdenOffset()

include <../config/Parameters_Main.scad>


module bowdenTube(hotendDescriptor, carriagePosition, extruderPosition, extraZ=120) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    color("White")
        bezierTube(extruderPosition + extruderBowdenOffset(), [carriagePosition.x, carriagePosition.y, eZ] + printheadBowdenOffset(hotendDescriptor), vitamin=true, extraZ=extraZ);
}

module printheadWiring(hotendDescriptor, carriagePosition, backFaceZipTiePositions) {
    segment = is_undef(carriagePosition);
    zp = backFaceZipTiePositions;
    assert(!is_undef(zp) || segment==true);
    assert(is_list(zp) || segment==true);
    assert(!is_undef(zp[0].x) || segment==true);
    printheadWiringPos = printheadWiringPos();
    assert(!is_undef(printheadWiringPos) || segment==true);

    if (segment)
        cable_wrap(500);

    xCarriageType = carriageType(_xCarriageDescriptor);
    endPos = printheadWiringOffset(hotendDescriptor) + (segment ? [0, 0, 0] : [carriagePosition.x, carriagePosition.y, eZ]);

    //echo(px=printheadWiringPosX());
    //assert(is_num(printheadWiringPosX()));
    y = eY + 2*eSizeY - printheadWireRadius();
    p0 = segment ? undef :
    [
        [ zp[0].x, y, zp[0].y ],
        [ zp[1].x, y, zp[1].y -5 ],
        [ zp[1].x, y, zp[1].y ],
        [ zp[1].x, y, zp[1].y + 5 ],
        [ zp[1].x, y, zp[1].y + 10 ],
        [ zp[1].x, y, zp[1].y + 15 ],
        [ zp[2].x, y, zp[2].y - 15],
        [ zp[2].x, y, zp[2].y - 12],
        [ zp[2].x, y, zp[2].y - 11],
        [ zp[2].x, y, zp[2].y - 10],
        [ zp[2].x, y, zp[2].y - 5],
        [ zp[2].x, y, zp[2].y ],
        [ zp[2].x, y, zp[2].y + 5],
        [ zp[3].x, y, zp[3].y - 5 ],
        [ zp[3].x, y, zp[3].y - 10 ],
        [ zp[3].x, y, zp[3].y - 11 ],
        [ zp[3].x, y, zp[3].y],
        [ zp[3].x, y, zp[3].y + 5],
        [ zp[3].x, y, zp[3].y + 6],
        [ zp[3].x, y, zp[3].y + 10],
        [ zp[3].x, y - 15, eZ - 10],
        [ zp[3].x, printheadWiringPos.y, eZ - 7],
        [ zp[3].x, printheadWiringPos.y, eZ - 6],
        [ zp[3].x, printheadWiringPos.y, eZ - 5],
        [ zp[3].x, printheadWiringPos.y, eZ],
        printheadWiringPos,
        printheadWiringPos + [0, -5, 5],
        printheadWiringPos + [0, -5, 50],
        printheadWiringPos + [0, -5, 100],
        (printheadWiringPos + endPos)/2 + [0, 0, 180],
        endPos + [0, 0, 101],
        endPos + [0, 0, 100],
        endPos + [0, 0, 50],
    ];
    p1 = [
        endPos + [0, 0, 35.1],
        endPos + [0, 0, 35],
        endPos + [0, 0, 34.9],
        endPos + [0, 0.1, 20],
        endPos,
    ];
    p = segment ? p1 : concat(p0, p1);
    color(grey(20))
        bezierTube2(p, tubeRadius=printheadWireRadius());
}

