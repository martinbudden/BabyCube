import cadquery as cq

from TypeDefinitions import T, Point2D


def wiringCutout(
    self: T,
) -> T:

    size = Point2D(6.5, 19.5)
    radius = 5
    result = (
        self
        .move(0, size.y/2)
        .sketch()
        .segment((-size.x/2, radius - size.y/2), (-size.x/2, -size.y/2))
        .segment((-size.x/2 - radius, -size.y/2))
        .arc((-size.x/2 - radius, radius - size.y/2), radius, -90, 90)
        .assemble(tag="face")
        .segment((size.x/2, radius - size.y/2), (size.x/2, -size.y/2))
        .segment((size.x/2 + radius, -size.y/2))
        .arc((size.x/2 + radius, radius - size.y/2), radius, 180, 90.0)
        .assemble(tag="face")
        .reset()
        .rect(size.x, size.y)
        .edges(">Y")
        .circle(radius)
    )

    return result.finalize()


cq.Workplane.wiringCutout = wiringCutout
