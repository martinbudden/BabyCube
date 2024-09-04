import cadquery as cq

from TypeDefinitions import T, Point2D, Point3D

import dogboneT
import TopFaceWiringCutout
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import backPlateThickness, frontPlateCFThickness, sizeZ, _zLeadScrewDiameter, _zRodDiameter, _zRodSeparation, _zRodOffsetY
from constants import M3_clearance_radius


def topFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    dogboneTolerance: float = 0,
    cuttingRadius: float = 1.5,
    kerf: float = 0,
) -> T:

    size = Point3D(sizeX, sizeY, sizeZ)

    result = (
        self
        .rect(size.x, size.y)
        .center(-size.x/2, -size.y/2) # set origin to bottom left corner of face
    )

    sideHoles = [(x, y) for x in [5.25, size.x - 5.25] for y in [30, size.y/2 - backPlateThickness/2]]
    backHoles = [(x, size.y - 5.5) for x in [30, size.x - 30]]
    frontHoles = [(size.x/2 - x, 8) for x in [15, -15]]
    idlerHoles = [(x, 8) for x in [25, size.x - 25]]
    motorHoles = [(x, size.y - 30 - backPlateThickness) for x in [5.5, size.x - 5.5]]
    railHoles = [(x, y) for x in [18.5, size.x - 18.5] for y in range(24, 200, 40)]
    zRodHoles = [(size.x/2 - x, size.y - _zRodOffsetY - backPlateThickness) for x in [-_zRodSeparation/2, _zRodSeparation/2]]

    result = (
        result
        .pushPoints(sideHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(railHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(frontHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(idlerHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(backHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(motorHoles)
        .circle(M3_clearance_radius - kerf/2)
        .moveTo(size.x/2, size.y - 7)
        .circle(M3_clearance_radius - kerf/2)
        .moveTo(size.x/2, size.y - _zRodOffsetY - backPlateThickness)
        .circle(_zLeadScrewDiameter/2 + 1 - kerf/2)
        .pushPoints(zRodHoles)
        .circle(_zRodDiameter/2 + 0.5 - kerf/2)
    )

    result = result.extrude(size.z)

    # main top cutout
    cutoutOffsetX = 28
    cutoutBackOffsetY = 41.5
    cutoutFrontOffsetY = 10.75 + frontPlateCFThickness
    cutoutSize = Point2D(size.x - 2*cutoutOffsetX, size.y - cutoutBackOffsetY - cutoutFrontOffsetY)
    result = (
        result
        .moveTo(size.x/2, cutoutSize.y/2 + cutoutFrontOffsetY)
        .sketch()
        .rect(cutoutSize.x, cutoutSize.y)
        .vertices()
        .fillet(4)
        .finalize()
        .cutThruAll()
    )
    result = result.moveTo(size.x/2 + 65, size.y - cutoutBackOffsetY).wiringCutout().cutThruAll()

    sideDogbones = [(0, y) for y in range(50, 190, 40)]
    frontAndBackDogbones = [(x, 0) for x in range(50, size.y - 40, 40)]
    cornerDogbones = [(x, 0) for x in [0, size.x]]

    result = (
        result
        # left side
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()

        # right side
        .center(size.x, 0)
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()

        # front
        .center(-size.x, 0)
        .pushPoints(frontAndBackDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
        .pushPoints(cornerDogbones)
        .dogboneT(40, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
        .pushPoints(cornerDogbones)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()

        # back
        .center(0, size.y)
        .pushPoints(frontAndBackDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
        .pushPoints(cornerDogbones)
        .dogboneT(40, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
        .center(0, -backPlateThickness)
        .pushPoints(cornerDogbones)
        .dogboneT(40, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
    )

    return result


#dxf = (cq.importers.importDXF("../BC220CF/dxfs/Top_Face_x220_y220.dxf").wires().toPending().extrude(sizeZ))

topFaceCNC = topFace(cq.Workplane("XY"), sizeX=220, sizeY=220 + backPlateThickness, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
#topFaceLSR = topFace(cq.Workplane("XY"), sizeX=220, sizeY=220 + backPlateThickness, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
#topFaceWJ  = topFace(cq.Workplane("XY"), sizeX=220, sizeY=220 + backPlateThickness, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)

#show_object(topFaceCNC)
#show_object(topFaceLSR)
#show_object(dxf)

