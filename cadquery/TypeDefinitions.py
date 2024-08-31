from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")

from collections import namedtuple
Point2D = namedtuple('Point2D', 'x y')
Point3D = namedtuple('Point3D', 'x y z')
