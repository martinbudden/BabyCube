import cadquery as cq

from TypeDefinitions import T, Point2D, Point3D

import dogboneT
from constants import fittingTolerance, cncKerf, cncCuttingRadius, dogboneChamfer, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import sizeZ, backPlateThickness
from constants import M3_clearance_radius


def leftFaceHoles(
    self: T,
    sizeX: float,
    sizeY: float,
    kerf: float = 0,
    grill: bool = True,
) -> T:

    size = Point2D(sizeX, sizeY)

    result = (
        self
        .rect(size.x, size.y)
        .center(-size.x/2, -size.y/2) # set origin to bottom left corner of face
    )

    baseHoles = [(x, 5) for x in [10, 76.5, size.x - 79.5, size.x - 13]]
    topHoles = [(x, size.y - 7) for x in [50, 90, 130]]
    frontHoles = [(8, 50)]
    idlerHoles = [(8, size.y - 44), (10, size.y - 15.5)]
    backHoles = [(size.x - 8, 50), (size.x - 8, 90)]
    motorHoles = [(size.x - 15, size.y - 18), (size.x - 38, size.y - 43.5)]

    result = (
        result
        .pushPoints(baseHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(topHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(frontHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(backHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(idlerHoles)
        .circle(M3_clearance_radius - kerf/2)
        .pushPoints(motorHoles)
        .circle(M3_clearance_radius - kerf/2)
    )

    grillHoles = [(55.3 + x*8.5, y) for x in range(0, 4) for y in range(15, 40, 5)]
    grillHoles2 = [(55.3 + 8.5/2 + x*8.5, y + 2.5) for x in range(0, 3) for y in range(15, 35, 5)]

    if grill:
        result = (
            result
            .pushPoints(grillHoles)
            .circle(M3_clearance_radius - kerf/2)
            .pushPoints(grillHoles2)
            .circle(M3_clearance_radius - kerf/2)
        )

    return result

def leftFace(
    self: T,
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    dogboneTolerance: float = 0,
    kerf: float = 0,
    grill: bool = True,
) -> T:

    size = Point3D(sizeX, sizeY, sizeZ)

    result = leftFaceHoles(self, size.x, size.y, kerf, grill)
    result = result.extrude(size.z)

    sideDogbones = [(0, y) for y in range(30, 210 + 1, 40)]
    topDogbones = [(x, size.y) for x in range(30, 190 + 1, 40)]

    result = (
        result
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .center(size.x, 0)
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, dogboneTolerance).cutThruAll()
        .center(-size.x, 0)
        .pushPoints(topDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, dogboneTolerance).cutThruAll()
    )
    # chamfer and fillet the dogbone edges to avoid sharp edges and ease assembly
    result = result.edges("|Z").chamfer(dogboneChamfer)
    result = result.edges("|Z").fillet(0.25)

    return result


def main() -> None:
    #dxf = (cq.importers.importDXF("../BC220CF/dxfs/Left_Face_y220_z210.dxf").wires().toPending().extrude(sizeZ))

    leftFaceCNC = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=sizeZ, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
    #leftFaceLSR = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=sizeZ, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
    #leftFaceWJ  = leftFace(cq.Workplane("XY"), sizeX=220+backPlateThickness, sizeY=210, sizeZ=sizeZ, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)

    show_object(leftFaceCNC)
    #show_object(leftFaceLSR)
    #show_object(dxf)


# check if running in cq-editor
if 'show_object' in globals():
    main()

