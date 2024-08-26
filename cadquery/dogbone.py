import cadquery as cq


from cadquery.occ_impl.geom import Vector, Plane, Location
from cadquery.occ_impl.shapes import (
    Shape,
    Edge,
    Wire,
    Face,
    Solid,
    Compound,
    wiresToFaces,
    Shapes,
)

from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

def dogbone(
    self: T,
    sizeX: float,
    sizeY: float,
    radius: float = 0,
    angle: float = 0,
    tolerance: float = 0,
    kerf: float = 0,
) -> T:
    """
    Returns a dogbone for each point on the stack.
    self refers to the CQ or Workplane object.
    :param sizeX: The x size of the dogbone
    :type sizeX: float > 0
    :param sizeY: The y size of the dogbone
    :type sizeY: float > 4*radius
    :param radius: The radius of the end of the dogbone
    :type radius: float > 0
    :return: A dogbone object for each point on the stack
    One dogbone is created for each item on the current stack. If no items are on the stack, one
    dogbone is created using the current workplane center.
    """

    x = (sizeX + tolerance - kerf)/2
    y = (sizeY - kerf)/2
    r = radius
    d = 2*radius


    p0 = Vector(0, y)
    p1 = Vector(x - d, y)
    a12 = Vector(x - r, y + r)
    p2 = Vector(x, y)

    p3 = Vector(x, -y)
    a34 = Vector(x - r, -y - r)
    p4 = Vector(x - d, -y)
    p5 = Vector(0, -y)

    p6 = Vector(-x + d, -y)
    a67 = Vector(-x + r, -y - r)
    p7 = Vector(-x, -y)

    p8 = Vector(-x, y)
    a89 = Vector(-x + r, y + r)
    p9 = Vector(-x + d, y)

    edges = [Edge.makeLine(p0, p1)]
    edges.append(Edge.makeThreePointArc(p1, a12, p2))
    edges.append(Edge.makeLine(p2, p3))
    edges.append(Edge.makeThreePointArc(p3, a34, p4))
    edges.append(Edge.makeLine(p4, p5))
    edges.append(Edge.makeLine(p5, p6))
    edges.append(Edge.makeThreePointArc(p6, a67, p7))
    edges.append(Edge.makeLine(p7, p8))
    edges.append(Edge.makeThreePointArc(p8, a89, p9))
    edges.append(Edge.makeLine(p9, p0))

    dogbone = Wire.assembleEdges(edges)
    dogbone = dogbone.rotate(Vector(), Vector(0, 0, 1), angle)

    return self.eachpoint(lambda loc: dogbone.moved(loc), True)

cq.Workplane.dogbone = dogbone
