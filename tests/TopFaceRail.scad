//!Displays the rail connectors.

include <../scad/printed/TopFaceRail.scad>


module RailConnector_test() {
    translate([-20, 0, -eZ])
        vflip()
            Y_Rail_Connector_stl();
    translate_z(-eZ)
        rotate([0, -90, 0])
            Y_Rail_Handle_stl();
}

if ($preview)
    RailConnector_test();
