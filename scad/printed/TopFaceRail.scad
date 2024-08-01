include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <../utils/carriageTypes.scad>
use <../printed/Handle.scad>

include <../config/Parameters_CoreXY.scad>


module railHolePositions(type, length, step=1) { //! Position children over screw holes
    pitch = rail_pitch(type);
    holeCount = rail_holes(type, length);
    for(i = [0 : step : holeCount - 1])
        translate([i * pitch - length / 2 + (length - (holeCount - 1) * pitch) / 2, 0])
            children();
}

module Y_Rail_Connector_stl() {
    stl_colour(pp3_colour)
        stl("Y_Rail_Connector")
            vflip() {
                yCarriageType = carriageType(_yCarriageDescriptor);
                yRailType = carriage_rail(yCarriageType);
                size = [10, eY - 15, 7];

                railOffset = yRailOffset(_xyNEMA_width);
                echo(railOffset=railOffset);
                translate_z(_topPlateThickness)
                    difference() {
                        translate([railOffset.x - size.x/2, (eY + 2*eSizeY - size.y)/2, railOffset.z])
                            rounded_cube_xy(size, 1);
                        translate(railOffset)
                            rotate([180, 0, 90])
                                railHolePositions(yRailType, _yRailLength, 2) {
                                    vflip()
                                        boltHoleM3Tap(size.z- 1);
                                    /*vflip()
                                        boltHoleM3(size.z);
                                    nut = M3_nut;
                                    radius = nut_radius(nut) + 0.1;
                                    depth = nut_thickness(nut) + 0.5 + 2*eps;
                                    translate_z(-size.z-eps)
                                        linear_extrude(depth)
                                            circle(r=radius, $fn=6);*/

                                }
                    }// end difference
            }
}

module Y_Rail_Handle_stl() {
    stl_colour(pp3_colour)
        stl("Y_Rail_Handle") 
            rotate([0, 90, 0]) {
                yCarriageType = carriageType(_yCarriageDescriptor);
                yRailType = carriage_rail(yCarriageType);
                size = [10, eY - 15, 7];

                railOffset = yRailOffset(_xyNEMA_width);
                translate_z(_topPlateThickness)
                    difference() {
                        translate([railOffset.x - size.x/2, (eY + 2*eSizeY - size.y)/2, railOffset.z]) {
                            rounded_cube_xy(size, 1);
                            translate([size.x/2, size.y/2, size.z - 5])
                                rotate([0, -90, 0])
                                    handle([size.x, 100, 35], gripSizeY=10, holeCount=0, extended=true);
                        }
                        translate(railOffset)
                            rotate([180, 0, 90])
                                railHolePositions(yRailType, _yRailLength, 2) {
                                    vflip()
                                        boltHoleM3Tap(size.z- 1, horizontal=true);
                                }
                    }// end difference
            }
}

