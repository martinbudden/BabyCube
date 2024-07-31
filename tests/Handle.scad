//!Displays a handle.

include <../scad/printed/Handle.scad>


//$explode=1;
module Handle_test() {
    //Handle_stl();
    //Handle2_stl();
    handleX();
}

module Handle_stl() {
    stl("Handle")
        color(pp1_colour)
            handle(size=[15, 100, 40], gripSizeY=15, holeCount=2, extended=true);
}

module handleX() {
    eY = 220;
    size = [10, eY - 15, 7];
    rounded_cube_yz(size, 1);
    length = 100;
    handleSize = [15, 15];
    /*translate([size.x/2, size.y/2, 0])
        rotate([0, 90, 0])
            handle(length2=length, height2=40, size=[15, size.x], holeCount=0, extended=true);*/
    size = [10, eY - 15, 7];
    translate([size.x/2, size.y/2, 0])
        rotate([0, -90, 0])
            handle([size.x, length, 40 + size.z], gripSizeY=15, holeCount=0, extended=true);
    //size = [gripSize.x, length2, height2];
}

module Handle2_stl() {
    size = [15, 85, 43];
    gripSizeY = 20;
    baseHeight = 5;

    stl("Handle2")
        color(pp1_colour)
            handle(size, gripSizeY, holeCount=1, extended=false);
    if ($preview)
        for (y = [size.y/2 + gripSizeY/2, -size.y/2 - gripSizeY/2])
            translate([baseHeight + 2.1, y, 0])
                rotate([90, 0, 90])
                    boltM4Countersunk(16);
}

module Handle_hardware(length=100, gripSizeY=15, baseHeight=5, bolt=true, TNut=true) {
    for (y = [length/2 + gripSizeY/2, -length/2 - gripSizeY/2, length/2 + gripSizeY/2 + 20, -gripSizeY/2 - size.x/2 - 20])
        translate([baseHeight, y, 0])
            rotate([90, 0, 90]) {
                explode(20, true)
                    if (bolt)
                        boltM4ButtonheadTNut(12, nutExplode=40);
                if (TNut)
                    boltM4TNut(12);
            }
}


if ($preview)
    Handle_test();
else
    Handle_stl();
