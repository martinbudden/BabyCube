include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>


module corkDamper(NEMA_type, thickness) {
    if (thickness)
        vitamin(str(": Cork damper ", NEMA_hole_pitch(NEMA_type)==31 ? "NEMA 17" : "NEMA 14" ));

    color("Tan")
        linear_extrude(thickness) {
            difference() {
                rounded_square([NEMA_width(NEMA_type), NEMA_width(NEMA_type)], 1, center=true);
                circle(r=NEMA_boss_radius(NEMA_type) + 1);
                NEMA_screw_positions(NEMA_type)
                    circle(r=M3_clearance_radius);
            }
        }
}
