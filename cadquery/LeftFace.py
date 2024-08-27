import cadquery as cq
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import backPlateThickness, sizeZ
from constants import M3_clearance_radius


def leftFaceHoles(
    self: T,
    sizeX: float,
    sizeY: float,
    kerf: float = 0,
    grill: bool = True
) -> T:

    baseHoles = [(x, 5 - sizeY/2) for x in [10 - sizeX/2, 76.5 - sizeX/2, sizeX/2 - 79.5, sizeX/2 - 13]]
    topHoles = [(x, sizeY/2 - 7) for x in [50 - sizeX/2, 90 - sizeX/2, 130 - sizeX/2]]
    frontHoles = [(8 - sizeX/2, 50 - sizeY/2)]
    idlerHoles = [(8 - sizeX/2, sizeY/2 - 44), (10 - sizeX/2, sizeY/2 - 15.5)]
    backHoles = [(sizeX/2 - 8, 50 - sizeY/2), (sizeX/2 - 8, 90 - sizeY/2)]
    motorHoles = [(sizeX/2 - 15, sizeY/2 - 18), (sizeX/2 - 38, sizeY/2 - 43.5)]

    grillHoles = [(55.3 + x*8.5 - sizeX/2, y - sizeY/2) for x in range(0, 4) for y in range(15, 40, 5)]
    grillHoles2 = [(55.3 + 8.5/2 + x*8.5 - sizeX/2, y+2.5 - sizeY/2) for x in range(0, 3) for y in range(15, 35, 5)]

    result = self \
        .rect(sizeX, sizeY) \
        .pushPoints(baseHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(topHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(frontHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(backHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(idlerHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(motorHoles) \
        .circle(M3_clearance_radius - kerf/2) \

    if grill:
        result = result \
            .pushPoints(grillHoles) \
            .circle(1.75 - kerf/2) \
            .pushPoints(grillHoles2) \
            .circle(1.75 - kerf/2) \

    return result

def leftFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    dogboneTolerance: float = 0,
    kerf: float = 0,
) -> T:

    result = leftFaceHoles(self, sizeX, sizeY, kerf)

    #range(start, end, step)
    leftDogbones = [(-sizeX/2, i - sizeY/2) for i in range(30, 210 + 1, 40)]
    rightDogbones = [(sizeX/2, i - sizeY/2) for i in range(30, 210 + 1, 40)]
    topDogbones = [(i - sizeX/2, sizeY/2) for i in range(30, 190 + 1, 40)]

    result = result.extrude(sizeZ) \
        .pushPoints(rightDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(topDogbones) \
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()

    return result


#dxf = (cq.importers.importDXF("../BC220CF/dxfs/Left_Face_y220_z210.dxf").wires().toPending().extrude(sizeZ))

#leftFaceCNC = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
leftFaceLSR = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
leftFaceWJ  = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)

#show_object(leftFaceCNC)
#show_object(leftFaceLSR)
#show_object(dxf)

if 'leftFaceCNC' in globals():
    exports(leftFaceCNC, "Left_Face_y220_z210", "CNC")
if 'leftFaceLSR' in globals():
    exports(leftFaceLSR, "Left_Face_y220_z210", "LSR")
if 'leftFaceWJ' in globals():
    exports(leftFaceWJ, "Left_Face_y220_z210", "WJ")
