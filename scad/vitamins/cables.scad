include <../global_defs.scad>

include <NopSCADlib/core.scad>


module stepper_motor_cable(length)
    vitamin(str(": Stepper motor cable, ", length, "mm"));

module usb_c_to_c_cable(length)
    vitamin(str(": USB C to C cable, ", length, "mm"));
