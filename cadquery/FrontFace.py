import cadquery as cq
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import backPlateThickness, sizeZ
from constants import M3_clearance_radius


def frontFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    dogboneTolerance: float = 0,
    kerf: float = 0,
) -> T:

    baseHoles = [(x, 5 - sizeY/2) for x in [65 - sizeX/2, sizeX/2 - 65]]
    topHoles = [(x, sizeY/2 - 8) for x in [25, -25]]
    idlerHoles = [(x, sizeY/2 - 15.5) for x in [30 - sizeX/2, sizeX/2 - 30]]
    sideHoles = [(x, y) for x in [6.5 - sizeX/2, sizeX/2 - 6.5] for y in [30 - sizeY/2, sizeY/2 - 60]]

    result = self \
        .rect(sizeX, sizeY) \
        .pushPoints(baseHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(topHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(idlerHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(sideHoles) \
        .circle(M3_clearance_radius - kerf/2)

    result = result.extrude(sizeZ)

    result = result \
        .moveTo(0, 7.5) \
        .sketch().rect(sizeX - 52, sizeY - 75) \
        .vertices() \
        .fillet(3) \
        .finalize() \
        .cutThruAll()

    leftDogbones = [(-sizeX/2, i - sizeY/2) for i in range(50, 210 + 1, 40)]
    rightDogbones = [(sizeX/2, i - sizeY/2) for i in range(50, 210 + 1, 40)]
    topDogbones = [(i - sizeX/2, sizeY/2) for i in range(30, 190 + 1, 40)]

    result = result \
        .pushPoints(rightDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .moveTo(-sizeX/2, -sizeY/2) \
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .moveTo(sizeX/2, -sizeY/2) \
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(topDogbones) \
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll() \

    return result


dxf = (cq.importers.importDXF("../BC220CF/dxfs/Front_Face_x220_z210.dxf").wires().toPending().extrude(sizeZ))

frontFaceCNC = frontFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
#frontFaceLSR = frontFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
#frontFaceWJ  = frontFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)

#show_object(frontFaceCNC)
#show_object(frontFaceLSR)
#show_object(dxf)

if 'frontFaceCNC' in globals():
    exports(frontFaceCNC, "Front_Face_x220_z210", "CNC")
if 'frontFaceLSR' in globals():
    exports(frontFaceLSR, "Front_Face_x220_z210", "LSR")
if 'frontFaceWJ' in globals():
    exports(frontFaceWJ, "Front_Face_x220_z210", "WJ")
