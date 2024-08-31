import cadquery as cq

from TypeDefinitions import T, Point3D

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

    size = Point3D(sizeX, sizeY, sizeZ)

    baseHoles = [(x, 5 - size.y/2) for x in [65 - size.x/2, size.x/2 - 65]]
    topHoles = [(x, size.y/2 - 8) for x in [25, -25]]
    idlerHoles = [(x, size.y/2 - 15.5) for x in [30 - size.x/2, size.x/2 - 30]]
    sideHoles = [(x, y) for x in [6.5 - size.x/2, size.x/2 - 6.5] for y in [30 - size.y/2, size.y/2 - 60]]

    result = (
        self
        .rect(size.x, size.y)
        .pushPoints(baseHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(topHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(idlerHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(sideHoles)
        .circle(M3_clearance_radius - kerf/2)
        .moveTo(0, 7.5)
    )

    result = result.extrude(size.z)

    result = (
        result
        .moveTo(0, 7.5)
        .sketch().rect(size.x - 52, size.y - 75)
        .vertices()
        .fillet(3)
        .finalize()
        .cutThruAll()
    )

    leftDogbones = [(-size.x/2, i - size.y/2) for i in range(50, 210 + 1, 40)]
    rightDogbones = [(size.x/2, i - size.y/2) for i in range(50, 210 + 1, 40)]
    topDogbones = [(i - size.x/2, size.y/2) for i in range(30, 190 + 1, 40)]

    result = (
        result
        .pushPoints(rightDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .moveTo(-size.x/2, -size.y/2)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .pushPoints(leftDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .moveTo(size.x/2, -size.y/2)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .pushPoints(topDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
    )

    return result


#dxf = (cq.importers.importDXF("../BC220CF/dxfs/Front_Face_x220_z210.dxf").wires().toPending().extrude(sizeZ))

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
