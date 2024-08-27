import cadquery as cq
from typing import (TypeVar)
T = TypeVar("T", bound="Workplane")


def wiringCutout(
    self: T,
) -> T:

    sizeX = 6.5
    sizeY = 19.5
    radius = 5
    result = (
        self
        .move(0, sizeY/2)
        .sketch()
        .segment((-sizeX/2, radius - sizeY/2), (-sizeX/2, -sizeY/2))
        .segment((-sizeX/2 - radius, -sizeY/2))
        .arc((-sizeX/2 - radius, radius-sizeY/2), radius, -90, 90)
        .assemble(tag="face")
        .segment((sizeX/2, radius-sizeY/2), (sizeX/2, -sizeY/2))
        .segment((sizeX/2 + radius, -sizeY/2))
        .arc((sizeX/2 + radius, radius-sizeY/2), radius, 180, 90.0)
        .assemble(tag="face")
        .reset() \
        .rect(sizeX, sizeY) \
        .edges(">Y") \
        .circle(radius) \
    )

    return result.finalize()


cq.Workplane.wiringCutout = wiringCutout
