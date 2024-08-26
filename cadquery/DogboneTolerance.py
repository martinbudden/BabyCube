import cadquery as cq
from dogbone import dogbone

sizeZ = 3
M3_clearance_radius = 3.3 / 2

cncCuttingRadius = 1.5
cncKerf = 0.0
lsrCuttingRadius = 0.3
lsrKerf = 0.3

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


    result = cq.Workplane("XY") \
        .rect(sizeX, sizeY) \
        .moveTo(20 - sizeX/2, 60 - sizeY/2) \
        .circle(1.5 - kerf2) \
        .moveTo(20 - sizeX/2, 40 - sizeY/2) \
        .circle(M3_clearance_radius - kerf2) \
        .moveTo(20 - sizeX/2, 20 - sizeY/2) \
        .circle(2.5 - kerf2) \
        .moveTo(40 - sizeX/2, 20 - sizeY/2) \
        .circle(1.5) \
        .moveTo(60 - sizeX/2, 20 - sizeY/2) \
        .circle(M3_clearance_radius) \
        .moveTo(80 - sizeX/2, 20 - sizeY/2) \
        .circle(2.5)


    # t0 on right side
    t0 = 0.025*10
    # t1 on bottom
    t1 = 0.050
    # t2 on left side
    t2 = 0.075
    # t3 on top
    t3 = 0.100

    result = result.extrude(sizeZ) \
        .pushPoints(rightDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, t0, kerf).cutThruAll() \
        .pushPoints(bottomDogbones) \
        .dogbone(20, 6, cuttingRadius, 0, t1, kerf).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, t2, kerf).cutThruAll() \
        .pushPoints(topDogbones) \
        .dogbone(20, 6, cuttingRadius, 0, t3, kerf).cutThruAll() \

    return result


dxf = (
    cq.importers.importDXF("../tests/DogboneToleranceCNC.dxf") \
    .wires() \
    .toPending() \
    .extrude(sizeZ)
)

dogboneToleranceCNC  = dogboneTolerance(120, 80, sizeZ, cncCuttingRadius, cncKerf)
dogboneToleranceLSR  = dogboneTolerance(120, 80, sizeZ, lsrCuttingRadius, lsrKerf)

cq.exporters.export(dogboneToleranceCNC, "DogboneTolerance_CNC.stl")
#cq.exporters.export(dogboneToleranceCNC.section(), "DogboneTolerance_CNC.dxf")
cq.exporters.export(dogboneToleranceCNC, "DogboneTolerance_CNC.step")

cq.exporters.export(dogboneToleranceLSR, "DogboneTolerance_LSR.stl")
#cq.exporters.export(dogboneToleranceLSR.section(), "DogboneTolerance_LSR.dxf")
cq.exporters.export(dogboneToleranceLSR, "DogboneTolerance_LSR.step")

show_object(dogboneToleranceCNC)
#show_object(dogboneToleranceLSR)
#show_object(dxf)
