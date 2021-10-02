include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/sweep.scad>

module leadscrewX(diameter, length, p, center=true) {//! Draw a leadscrew with the specified length, diameter and pitch
    vitamin(str("leadscrewX(", diameter, ", ", length, ") : Leadscrew ", diameter, "mm x ", length, "mm"));

    assert(diameter >= 4, "Leadscrew diameter must be >= 4");
    pitch = p ? p : diameter > 10 ? 3 : 2;
    minorDiameter =
        diameter <= 6 ? diameter - 1 :
        diameter <= 10 ? diameter - pitch - 0.5 :
        diameter - pitch - 0.75;

    color(grey(70)) {
        cylinder(d=minorDiameter, h=length, center=center);
        translate_z((center ? -length/2 : 0) + pitch/4) { // additional pitch/4 elevation so thread does not protrude from bottom of rod
            // set up a square profile for the thread
            a = max(diameter - minorDiameter, 1)/2;
            r = (diameter + minorDiameter + pitch)/4;
            profile = [  [-pitch/4, -(diameter/2 - a)/2, 0],
                         [ pitch/4, -(diameter/2 - a)/2, 0],
                         [ pitch/4,  (diameter/2 - r)/2, 0],
                         [-pitch/4,  (diameter/2 - r)/2, 0]
                    ];

            // create a spiral that is one turn of the thread, with one segment of overlap
            count = ceil(max(min(360/$fa, diameter*PI/$fs)/2, 5));
            step = 360/count;
            spiral = [ for (i = [0 : step : 360 + step]) [r*sin(i), -r*cos(i), i*pitch/360] ];

            // do as many full turns as will fully fit in the length
            turnCount = floor((length - pitch/2)/pitch);
            for (i = [0 : turnCount - 1])
                translate_z(i*pitch)
                    sweep(spiral, profile, loop=false, twist=30);

            // add a partial turn at the end
            end = ((length - pitch/2) - turnCount*pitch)/pitch*360 - 20;
            if (end > 20) {
                spiralTop = [ for (i = [0: step: end]) [r*sin(i), -r*cos(i), i*pitch/360] ];
                translate_z(turnCount * pitch)
                    sweep(spiralTop, profile, loop=false, twist=30*end/360);
            }
        }
    }
}
