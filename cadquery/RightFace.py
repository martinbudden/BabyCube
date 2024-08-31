import cadquery as cq

from TypeDefinitions import T, Point2D, Point3D

import dogboneT
from exports import exports
from LeftFace import leftFaceHoles
from fans import fan30x10, fan_bore, fan_hole_pitch
from stepper_motors import NEMA17_40, NEMA_boss_radius, NEMA_hole_pitch

from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import backPlateThickness, sizeZ
from constants import M3_clearance_radius, M4_clearance_radius


def rightFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    dogboneTolerance: float = 0,
    cuttingRadius: float = 1.5,
    kerf: float = 0,
) -> T:

    size = Point3D(sizeX, sizeY, sizeZ)

    result = leftFaceHoles(self, size.x, size.y, kerf, grill=False)

    fan = fan30x10
    result = (
        result
        .moveTo(68 - size.x/2, 25 - size.y/2)
        .circle(fan_bore(fan)/2 - 0.5)
        .rect(2*fan_hole_pitch(fan), 2*fan_hole_pitch(fan), forConstruction=True)
        .vertices()
        .circle(M3_clearance_radius - kerf/2)
    )

    motor = NEMA17_40
    result = (
        result
        .moveTo(size.x/2 - 75, size.y/2 - 73)
        .circle(NEMA_boss_radius(motor) + 0.25)
        .rect(NEMA_hole_pitch(motor), NEMA_hole_pitch(motor), forConstruction=True)
        .vertices()
        .circle(M3_clearance_radius - kerf/2)
    )

    # spool holder
    result = (
        result
        .pushPoints([(x - size.x/2, size.y/2 - 80) for x in [8, 45]])
        .circle(M3_clearance_radius - kerf/2)
    )

    # ICE
    iecPosition = Point2D(175.5 - size.x/2, 33 - size.y/2)
    result = (
        result
        .pushPoints([(iecPosition.x, iecPosition.y + y) for y in [-20, 20]])
        .circle(M4_clearance_radius - kerf/2)
    )
    iecCutoutSize = Point2D(48, 30)
    result = (
        result.extrude(size.z)
        .moveTo(iecPosition.x, iecPosition.y)
        .sketch().rect(iecCutoutSize.x, iecCutoutSize.y)
        .vertices()
        .fillet(5)
        .finalize()
        .cutThruAll()
    )

    leftDogbones = [(-size.x/2, i - size.y/2) for i in range(30, 210 + 1, 40)]
    rightDogbones = [(size.x/2, i - size.y/2) for i in range(30, 210 + 1, 40)]
    topDogbones = [(i - size.x/2, size.y/2) for i in range(30, 190 + 1, 40)]

    result = (
        result
        .pushPoints(rightDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .pushPoints(leftDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .pushPoints(topDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
    )

    return result


dxf = (cq.importers.importDXF("../BC220CF/dxfs/Right_Face_y220_z210.dxf").wires().toPending().extrude(sizeZ))

rightFaceCNC = rightFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
#rightFaceLSR = rightFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
#rightFaceWJ  = rightFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)

#show_object(rightFaceCNC)
#show_object(rightFaceLSR)
#show_object(dxf)

if 'rightFaceCNC' in globals():
    exports(rightFaceCNC, "Right_Face_y220_z210", "CNC")
if 'rightFaceLSR' in globals():
    exports(rightFaceLSR, "Right_Face_y220_z210", "LSR")
if 'rightFaceWJ' in globals():
    exports(rightFaceWJ, "Right_Face_y220_z210", "WJ")
