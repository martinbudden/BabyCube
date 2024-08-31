import cadquery as cq

from TypeDefinitions import T, Point3D


import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import sizeZ, eSizeZ, backPlateThickness, _zRodSeparation
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

    kerf2 = kerf/2

    sk_sizeZ = 14
    sk_screw_separation = 32
    zRodOffsetX = (size.x - _zRodSeparation)/2;
    skBracketHoles = [(zRodOffsetX + x + s -size.x/2, -size.y/2 + y) for x in [0, _zRodSeparation] for s in [-sk_screw_separation/2, sk_screw_separation/2] for y in [sk_sizeZ/2 + 7, size.y - sk_sizeZ/2 - 3]]

    eSizeZ = 10
    topPlateThickness = 3
    topHoles = [(x, size.y/2 - topPlateThickness - eSizeZ/2) for x in [-15, 15]]

    zMotorMountHoles = [(132.25 - size.x/2, 39.5 - size.y/2), (87.75 - size.x/2, 39.5 - size.y/2)]
    backFaceCFSideHoles = [(x, y - size.y/2) for x in [8 - size.x/2, size.x/2 - 8] for y in [30, 110]]
    backFaceBracketHoles = [(30 - size.x/2, 15 - size.y/2), (size.x/2 - 30, 15 - size.y/2)]
    backFaceHoles = [(8 - size.x/2, 6 - size.y/2),(size.x/2 - 8, 6 - size.y/2)]

    xyMotorMountBackHoles = [(8 - size.x/2, size.y/2 - 8), (size.x/2 - 8, size.y/2 - 8), (37 - size.x/2, size.y/2 - 43.5), (size.x/2 - 37, size.y/2 - 43.5)]

    result = (
        self
        .rect(size.x, size.y)
        .pushPoints(skBracketHoles)
        .circle(M5_clearance_radius - kerf2)
        .pushPoints(topHoles)
        .circle(M3_clearance_radius - kerf2)
        .pushPoints(zMotorMountHoles)
        .circle(M3_clearance_radius - kerf2)
        .pushPoints(backFaceCFSideHoles)
        .circle(M3_clearance_radius - kerf2)
        .pushPoints(xyMotorMountBackHoles)
        .circle(M3_clearance_radius - kerf2)
        .pushPoints(backFaceBracketHoles)
        .circle(M3_clearance_radius - kerf2)
        .pushPoints(backFaceHoles)
        .circle(M3_clearance_radius - kerf2)
    )


    #range(start, end, step)
    leftDogbones = [(-size.x/2, i - size.y/2) for i in range(50, 210 + 1, 40)]
    rightDogbones = [(size.x/2, i - size.y/2) for i in range(50, 210 + 1, 40)]
    topDogbones = [(i - size.x/2, size.y/2) for i in range(30, 190 + 1, 40)]

    result = (
        result
        .extrude(sizeZ)
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




