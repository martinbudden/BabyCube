import cadquery as cq
from dogbone import dogboneT
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

from constants import cncCuttingRadius, fittingTolerance, lsrKerf, lsrCuttingRadius
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

#leftFaceCNC = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, cuttingRadius=cncCuttingRadius, dogboneTolerance=fittingTolerance, kerf=0)
leftFaceLSR = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, cuttingRadius=lsrCuttingRadius, dogboneTolerance=fittingTolerance, kerf=lsrKerf)

#show_object(leftFaceCNC)
#show_object(leftFaceLSR)
#show_object(dxf)

#cq.exporters.export(leftFaceCNC, "Left_Face_y220_z210_CNC.stl")
if 'leftFaceCNC' in globals():
    cq.exporters.export(leftFaceCNC.section(), "Left_Face_y220_z210_CNC.dxf")
#cq.exporters.export(leftFaceCNC, "Left_Face_y220_z210_CNC.step")

#cq.exporters.export(leftFaceLSR, "Left_Face_y220_z210_LSR.stl")
if 'leftFaceLSR' in globals():
    cq.exporters.export(leftFaceLSR.section(), "Left_Face_y220_z210_LSR.dxf")
#cq.exporters.export(leftFaceLSR, "Left_Face_y220_z210_LSR.step")