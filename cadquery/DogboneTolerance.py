import cadquery as cq

import dogboneT
from exports import exports
from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import backPlateThickness, sizeZ
from constants import M3_clearance_radius

def dogboneTolerance(
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    kerf: float = 0,
):
    kerf2 = lsrCuttingRadius / 2

    #range(start, end, step)
    leftDogbones = [(-sizeX/2, i) for i in range(-40, 40 + 1, 40)]
    rightDogbones = [(sizeX/2, i) for i in range(-40, 40 + 1, 40)]
    topDogbones = [(i, sizeY/2) for i in range(-60, 60 + 1, 40)]
    bottomDogbones = [(i, -sizeY/2) for i in range(-60, 60 + 1, 40)]


    result = (
        cq.Workplane("XY")
        .rect(sizeX, sizeY)
        .moveTo(20 - sizeX/2, 60 - sizeY/2)
        .circle(1.5 - kerf2)
        .moveTo(20 - sizeX/2, 40 - sizeY/2)
        .circle(M3_clearance_radius - kerf2)
        .moveTo(20 - sizeX/2, 20 - sizeY/2)
        .circle(2.5 - kerf2)
        .moveTo(40 - sizeX/2, 20 - sizeY/2)
        .circle(1.5)
        .moveTo(60 - sizeX/2, 20 - sizeY/2)
        .circle(M3_clearance_radius)
        .moveTo(80 - sizeX/2, 20 - sizeY/2)
        .circle(2.5)
    )


    # t0 on right side
    t0 = 0.025*10
    # t1 on bottom
    t1 = 0.050
    # t2 on left side
    t2 = 0.075
    # t3 on top
    t3 = 0.100

    result = (
        result.extrude(sizeZ)
        .pushPoints(rightDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, t0, kerf).cutThruAll()
        .pushPoints(bottomDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, t1, kerf).cutThruAll()
        .pushPoints(leftDogbones)
        .dogboneT(20, 6, cuttingRadius, 90, t2, kerf).cutThruAll()
        .pushPoints(topDogbones)
        .dogboneT(20, 6, cuttingRadius, 0, t3, kerf).cutThruAll()
    )

    return result


dxf = (
    cq.importers.importDXF("../tests/DogboneToleranceCNC.dxf")
    .wires()
    .toPending()
    .extrude(sizeZ)
)

dogboneToleranceCNC  = dogboneTolerance(120, 80, sizeZ, cncCuttingRadius, cncKerf)
dogboneToleranceLSR  = dogboneTolerance(120, 80, sizeZ, lsrCuttingRadius, lsrKerf)
dogboneToleranceWJ  = dogboneTolerance(120, 80, sizeZ, wjCuttingRadius, wjKerf)

if 'dogboneToleranceCNC' in globals():
    exports(dogboneToleranceCNC, "DogboneTolerance", "CNC")
if 'dogboneToleranceLSR' in globals():
    exports(dogboneToleranceLSR, "DogboneTolerance", "LSR")
if 'dogboneToleranceWJ' in globals():
    exports(dogboneToleranceWJ, "DogboneTolerance", "WJ")



cq.exporters.export(dogboneToleranceCNC, "DogboneTolerance_CNC.stl")
#cq.exporters.export(dogboneToleranceCNC.section(), "DogboneTolerance_CNC.dxf")
cq.exporters.export(dogboneToleranceCNC, "DogboneTolerance_CNC.step")

cq.exporters.export(dogboneToleranceLSR, "DogboneTolerance_LSR.stl")
#cq.exporters.export(dogboneToleranceLSR.section(), "DogboneTolerance_LSR.dxf")
cq.exporters.export(dogboneToleranceLSR, "DogboneTolerance_LSR.step")

show_object(dogboneToleranceCNC)
#show_object(dogboneToleranceLSR)
#show_object(dxf)
