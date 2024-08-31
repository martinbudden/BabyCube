import cadquery as cq

from TypeDefinitions import T, Point3D

import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import sizeZ, eSizeZ, topPlateThickness, _zRodSeparation
from constants import M3_clearance_radius, M5_clearance_radius


def backFace(
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

    sk_sizeZ = 14
    sk_screw_separation = 32
    zRodOffsetX = (size.x - _zRodSeparation)/2;
    skBracketHoles = [(zRodOffsetX + x + s, y) for x in [0, _zRodSeparation] for s in [-sk_screw_separation/2, sk_screw_separation/2] for y in [sk_sizeZ/2 + 7, size.y - sk_sizeZ/2 - 3]]

    topHoles = [(size.x/2 + x, size.y - topPlateThickness - eSizeZ/2) for x in [-15, 15]]

    backFaceCFSideHoles = [(x, y) for x in [8, size.x - 8] for y in [30, 110]]
    backFaceBracketHoles = [(x, 15) for x in [30, size.x - 30]]
    backFaceHoles = [(8, 6), (size.x - 8, 6)]

    xyMotorMountBackHoles = [(8, size.y - 8), (size.x - 8, size.y - 8), (37, size.y - 43.5), (size.x - 37, size.y - 43.5)]
    zMotorMountHoles = [(132.25, 39.5), (87.75, 39.5)]

    result = (
        result
        .pushPoints(skBracketHoles)
        .circle(M5_clearance_radius - kerf/2)
        .pushPoints(topHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(zMotorMountHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(backFaceCFSideHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(xyMotorMountBackHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(backFaceBracketHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(backFaceHoles)
        .circle(M3_clearance_radius - kerf/2)
    )

    result = result.extrude(size.z)

    sideDogbones = [(0, y) for y in range(50, 210 + 1, 40)]
    topDogbones = [(x, size.y) for x in range(30, 190 + 1, 40)]

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

    return result

#dxf = (cq.importers.importDXF("../BC220CF/dxfs/Back_Face_x220_z210.dxf").wires().toPending().extrude(sizeZ))

backFaceCNC = backFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, cuttingRadius=cncCuttingRadius, dogboneTolerance=fittingTolerance, kerf=cncKerf)
#backFaceLSR = backFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, cuttingRadius=lsrCuttingRadius, dogboneTolerance=fittingTolerance, kerf=lsrKerf)
#backFaceWJ = backFace(cq.Workplane("XY"), sizeX=220, sizeY=210, sizeZ=3, cuttingRadius=wjCuttingRadius, dogboneTolerance=fittingTolerance, kerf=wjKerf)

if 'backFaceCNC' in globals():
    exports(backFaceCNC, "Back_Face_x220_z210", "CNC")
if 'backFaceLSR' in globals():
    exports(backFaceLSR, "Back_Face_x220_z210", "LSR")
if 'backFaceWJ' in globals():
    exports(backFaceWJ, "Back_Face_x220_z210", "WJ")

#show_object(backFaceCNC)
#show_object(backFaceLSR)
#show_object(dxf)




