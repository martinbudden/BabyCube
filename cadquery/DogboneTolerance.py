import cadquery as cq

from TypeDefinitions import T, Point3D

import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, dogboneChamfer, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import sizeZ
from constants import M3_clearance_radius

def dogboneTolerance(
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    kerf: float = 0,
) -> T:

    size = Point3D(sizeX, sizeY, sizeZ)

    result = (
        cq.Workplane("XY")
        .rect(size.x, size.y)
        .center(-size.x/2, -size.y/2) # set origin to bottom left corner of rectangle
    )

    kerf2 = lsrCuttingRadius / 2 # for test holes with kerf use this kerf

    result = (
        result
        .moveTo(20, 60)
        .circle(1.5 - kerf2)
        .moveTo(20, 40)
        .circle(M3_clearance_radius - kerf2)
        .moveTo(20, 20)
        .circle(2.5 - kerf2)
        .moveTo(40, 20)
        .circle(1.5)
        .moveTo(60, 20)
        .circle(M3_clearance_radius)
        .moveTo(80, 20)
        .circle(2.5)
    )

    result = result.extrude(size.z)

    # t0 on right side
    t0 = 0.025
    # t1 on bottom
    t1 = 0.050
    # t2 on left side
    t2 = 0.075
    # t3 on top
    t3 = 0.100

    sideDogbones = [(0, y) for y in range(0, 80 + 1, 40)]
    topAndBottomDogbones = [(x, 0) for x in range(0, 120 + 1, 40)]

    result = (
        result
        # left side
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, t2, kerf).cutThruAll()

        # right side
        .center(size.x, 0)
        .pushPoints(sideDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, t0, kerf).cutThruAll()

        # bottom side
        .center(-size.x, 0)
        .pushPoints(topAndBottomDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, t1, kerf).cutThruAll()

        # tip side
        .center(0, size.y)
        .pushPoints(topAndBottomDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, t3, kerf).cutThruAll()
    )
    # chamfer and fillet the dogbone edges to avoid sharp edges and ease assembly
    result = result.edges("|Z").chamfer(dogboneChamfer)
    result = result.edges("|Z").fillet(0.25)

    return result


def main() -> None:
    #dxf = (cq.importers.importDXF("../tests/DogboneToleranceCNC.dxf").wires().toPending().extrude(sizeZ))

    dogboneToleranceCNC  = dogboneTolerance(120, 80, sizeZ, cncCuttingRadius, cncKerf)
    #dogboneToleranceLSR  = dogboneTolerance(120, 80, sizeZ, lsrCuttingRadius, lsrKerf)
    #dogboneToleranceWJ  = dogboneTolerance(120, 80, sizeZ, wjCuttingRadius, wjKerf)

    if 'dogboneToleranceCNC' in locals():
        print("exporting DogboneTolerance CNC")
        exports(dogboneToleranceCNC, "DogboneTolerance", "CNC")
        if 'show_object' in globals():
            show_object(dogboneToleranceCNC)

    if 'dogboneToleranceLSR' in locals():
        print("exporting DogboneTolerance LSR")
        exports(dogboneToleranceLSR, "DogboneTolerance", "LSR")
        if 'show_object' in globals():
            show_object(dogboneToleranceLSR)

    if 'dogboneToleranceWJ' in locals():
        print("exporting DogboneTolerance WJ")
        exports(dogboneToleranceWJ, "DogboneTolerance", "WJ")
        if 'show_object' in globals():
            show_object(dogboneToleranceWJ)


# check if running in cq-editor
if __name__ == '__main__' or 'show_object' in globals():
    main()
