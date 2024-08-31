import cadquery as cq

from TypeDefinitions import T, Point2D, Point3D

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

    result = (
        self
        .rect(size.x, size.y)
        .center(-size.x/2, -size.y/2) # set origin to bottom left corner of face
    )

    baseHoles = [(x, 5) for x in [65, size.x - 65]]
    topHoles = [(x + size.x/2, size.y - 8) for x in [25, -25]]
    idlerHoles = [(x, size.y - 15.5) for x in [30, size.x - 30]]
    sideHoles = [(x, y) for x in [6.5, size.x - 6.5] for y in [30, size.y - 60]]

    result = (
        result
        .pushPoints(baseHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(topHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(idlerHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(sideHoles)
        .circle(M3_clearance_radius - kerf/2)
    )

    result = result.extrude(size.z)

    sideDogbones = [(0, i) for i in range(50, 210 + 1, 40)]
    topDogbones = [(i, size.y) for i in range(30, 190 + 1, 40)]

    result = (
        result
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .moveTo(0, 0)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .center(size.x, 0)
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .moveTo(0, 0)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .center(-size.x, 0)
        .pushPoints(topDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
    )

    cutoutBackOffsetY = 30
    cutoutFrontOffsetY = 45
    cutoutSize = Point2D(size.x - 52, size.y - cutoutBackOffsetY - cutoutFrontOffsetY)

    result = (
        result.faces(">Z")
        .moveTo(size.x/2, cutoutSize.y/2 + cutoutFrontOffsetY)
        .sketch()
        .rect(cutoutSize.x, cutoutSize.y)
        .vertices()
        .fillet(3)
        .finalize()
        .cutThruAll()
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
