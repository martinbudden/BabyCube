import cadquery as cq
from dogbone import dogboneT
from LeftFace import leftFaceHoles
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

from constants import cncCuttingRadius, fittingTolerance, lsrKerf, lsrCuttingRadius
from constants import backPlateThickness, sizeZ
from constants import M3_clearance_radius


def rightFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    dogboneTolerance: float = 0,
    kerf: float = 0,
) -> T:

    result = leftFaceHoles(self, sizeX, sizeY, kerf, grill=False)

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


dxf = (cq.importers.importDXF("../BC220CF/dxfs/Right_Face_y220_z210.dxf").wires().toPending().extrude(sizeZ))

rightFaceCNC = rightFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, cuttingRadius=cncCuttingRadius, dogboneTolerance=fittingTolerance, kerf=0)
#rightFaceLSR = rightFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, cuttingRadius=lsrCuttingRadius, dogboneTolerance=fittingTolerance, kerf=lsrKerf)

#show_object(rightFaceCNC)
#show_object(rightFaceLSR)
#show_object(dxf)

#cq.exporters.export(rightFaceCNC, "Right_Face_y220_z210_CNC.stl")
if 'rightFaceCNC' in globals():
    cq.exporters.export(rightFaceCNC.section(), "Right_Face_y220_z210_CNC.dxf")
#cq.exporters.export(leftFaceCNC, "Right_Face_y220_z210_CNC.step")

#cq.exporters.export(rightFaceLSR, "Right_Face_y220_z210_LSR.stl")
if 'rightFaceLSR' in globals():
    cq.exporters.export(rightFaceLSR.section(), "Right_Face_y220_z210_LSR.dxf")
#cq.exporters.export(rightFaceLSR, "Right_Face_y220_z210_LSR.step")