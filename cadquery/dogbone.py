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
    xLen: float,
    yLen: float,
    radius: float = 0,
    angle: float = 0,
) -> T:
    """
    Returns a dogbone for each point on the stack.
    self refers to the CQ or Workplane object.
    :param xLen: length in the x direction (in workplane coordinates)
    :type xLen: float > 4*radius
    :param yLen: length in the y direction (in workplane coordinates)
    :type yLen: float > 4*radius
    :param radius: The radius of the end of the dogbone
    :type radius: float > 0
    :return: A dogbone object for each point on the stack
    One dogbone is created for each item on the current stack. If no items are on the stack, one
    dogbone is created using the current workplane center.
    """

    x = xLen/2
    y = yLen/2
    r = radius
    d = 2*radius

    p1 = Vector(x - d, y)
    a12 = Vector(x - r, y + r)
    p2 = Vector(x, y)

    p3 = Vector(x, -y)
    a34 = Vector(x - r, -y - r)
    p4 = Vector(x - d, -y)

    p5 = Vector(-x + d, -y)
    a56 = Vector(-x + r, -y - r)
    p6 = Vector(-x, -y)

    p7 = Vector(-x, y)
    a78 = Vector(-x + r, y + r)
    p8 = Vector(-x + d, y)

    edges = [Edge.makeLine(p8, p1)]
    edges.append(Edge.makeThreePointArc(p1, a12, p2))
    edges.append(Edge.makeLine(p2, p3))
    edges.append(Edge.makeThreePointArc(p3, a34, p4))
    edges.append(Edge.makeLine(p4, p5))
    edges.append(Edge.makeThreePointArc(p5, a56, p6))
    edges.append(Edge.makeLine(p6, p7))
    edges.append(Edge.makeThreePointArc(p7, a78, p8))

    dogbone = Wire.assembleEdges(edges)
    dogbone = dogbone.rotate(Vector(), Vector(0, 0, 1), angle)

    return self.eachpoint(lambda loc: dogbone.moved(loc), True)

cq.Workplane.dogbone = dogbone
