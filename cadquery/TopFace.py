import cadquery as cq
from dogbone import dogboneT
from LeftFace import leftFaceHoles
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

from constants import cncCuttingRadius, fittingTolerance, lsrKerf, lsrCuttingRadius
from constants import backPlateThickness, sizeZ, _zLeadScrewDiameter, _zRodDiameter, _zRodSeparation, _zRodOffsetY
from constants import M3_clearance_radius


def topFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    dogboneTolerance: float = 0,
    kerf: float = 0,
) -> T:

    sideHoles = [(x, y) for x in [5.25 - sizeX/2, sizeX/2 - 5.25] for y in [30 - sizeY/2, -backPlateThickness/2]]
    backHoles = [(x, sizeY/2 - 5.5) for x in [30 - sizeX/2, sizeX/2 - 30]]
    frontHoles = [(x, 8 - sizeY/2) for x in [15, -15]]
    idlerHoles = [(x, 8 - sizeY/2) for x in [25 - sizeX/2, sizeX/2 - 25]]
    motorHoles = [(x, sizeY/2 - 30 - backPlateThickness) for x in [5.5 - sizeX/2, sizeX/2 - 5.5]]
    railHoles = [(x, y - sizeY/2) for x in [18.5 - sizeX/2, sizeX/2 - 18.5] for y in range(24, 200, 40)]
    zRodHoles = [(x, sizeY/2 - _zRodOffsetY - backPlateThickness) for x in [-_zRodSeparation/2, _zRodSeparation/2]]

    result = self \
        .rect(sizeX, sizeY) \
        .pushPoints(sideHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(railHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(frontHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(idlerHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(backHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .pushPoints(motorHoles) \
        .circle(M3_clearance_radius - kerf/2) \
        .moveTo(0, sizeY/2 - 7) \
        .circle(M3_clearance_radius - kerf/2) \
        .moveTo(0, sizeY/2 - _zRodOffsetY - backPlateThickness) \
        .circle(_zLeadScrewDiameter/2 + 1 - kerf/2) \
        .pushPoints(zRodHoles) \
        .circle(_zRodDiameter/2 + 0.5 - kerf/2) \

    result = result.extrude(sizeZ)

    result = result \
        .moveTo(0, -14) \
        .sketch().rect(sizeX - 56, sizeY - 55) \
        .vertices() \
        .fillet(4) \
        .finalize() \
        .cutThruAll()

    leftDogbones = [(-sizeX/2, i - sizeY/2) for i in range(50, 190, 40)]
    rightDogbones = [(sizeX/2, i - sizeY/2) for i in range(50, 190, 40)]
    frontDogbones = [(i - sizeX/2, -sizeY/2) for i in range(10, sizeY, 40)]
    backDogbones = [(i - sizeX/2, sizeY/2) for i in range(10, sizeY, 40)]
    cornerDogbones = [(x, y) for x in [-sizeX/2, sizeX/2] for y in [-sizeY/2, sizeY/2 - backPlateThickness]]

    result = result \
        .pushPoints(rightDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \
        .pushPoints(frontDogbones) \
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll() \
        .pushPoints(backDogbones) \
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll() \
        .pushPoints(cornerDogbones) \
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll() \

    return result


#dxf = (cq.importers.importDXF("../BC220CF/dxfs/Top_Face_x220_y220.dxf").wires().toPending().extrude(sizeZ))

topFaceCNC = topFace(cq.Workplane("XY"), sizeX=220, sizeY=220 + backPlateThickness, sizeZ=3, cuttingRadius=cncCuttingRadius, dogboneTolerance=fittingTolerance, kerf=0)
#topFaceLSR = topFace(cq.Workplane("XY"), sizeX=220, sizeY=220 + backPlateThickness, sizeZ=3, cuttingRadius=lsrCuttingRadius, dogboneTolerance=fittingTolerance, kerf=lsrKerf)

#show_object(topFaceCNC)
#show_object(topFaceLSR)
#show_object(dxf)

#cq.exporters.export(topFaceCNC, "Top_Face_x220_y220_CNC.stl")
if 'topFaceCNC' in globals():
    cq.exporters.export(topFaceCNC.section(), "Top_Face_x220_y220_CNC.dxf")
#cq.exporters.export(leftFaceCNC, "Top_Face_x220_y220_CNC.step")

#cq.exporters.export(topFaceLSR, "Top_Face_x220_y220_LSR.stl")
if 'topFaceLSR' in globals():
    cq.exporters.export(topFaceLSR.section(), "Top_Face_x220_y220_LSR.dxf")
#cq.exporters.export(topFaceLSR, "Top_Face_x220_y220_LSR.step")