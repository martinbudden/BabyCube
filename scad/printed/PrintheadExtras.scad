include <../config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

include <../utils/bezierTube.scad>
include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>
include <../utils/HolePositions.scad>
include <../vitamins/cables.scad>
use <../vitamins/extruder.scad> // for extruderBowdenOffset()
use <../printed/LeftAndRightFaces.scad> // for extruderPosition()

use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>

include <../config/Parameters_Main.scad>


module bowdenTube(carriagePosition, hotendDescriptor, extraZ=120) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    color("White")
        bezierTube(extruderPosition(_xyNEMA_width) + extruderBowdenOffset(), [carriagePosition.x + eSizeX - 6 - xCarriageBeltSideSize(xCarriageType).x/2, carriagePosition.y + carriage_size(xCarriageType).y/2 + 5, eZ] + printheadBowdenOffset(hotendDescriptor), ptfeTube=true, extraZ=extraZ);
}

module printheadWiring(carriagePosition, hotendDescriptor, backFaceZipTiePositions) {
    zp = backFaceZipTiePositions;
    assert(!is_undef(zp));
    assert(is_list(zp));
    assert(!is_undef(zp[0].x));
    printheadWiringPos = printheadWiringPos();
    assert(!is_undef(printheadWiringPos));
    cable_wrap(500);

    xCarriageType = carriageType(_xCarriageDescriptor);    
    endPos = [carriagePosition.x + eSizeX - 6 - xCarriageBeltSideSize(xCarriageType).x/2, carriagePosition.y + carriage_size(xCarriageType).y/2 + 5, eZ] + printheadWiringOffset(hotendDescriptor);

    //echo(px=printheadWiringPosX());
    //assert(is_num(printheadWiringPosX()));
    y = eY + 2*eSizeY - printheadWireRadius();
    p = [
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
        endPos + [0, 0, 100],
        endPos + [0, 0, 50],
        endPos,
    ];
    color(grey(20))
        bezierTube2(p, tubeRadius=printheadWireRadius());
}

