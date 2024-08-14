//!# BabyCube Assembly Instructions
//!
//!These are the assembly instructions for the BabyCube. These instructions are not fully comprehensive, that is they do
//!not show every small detail of the construction, and in particular they do not show the wiring. However there is sufficient
//!detail that someone with a good understanding of 3D printers can build the BabyCube.
//!
//!![Main Assembly](assemblies/main_assembled.png)
//!
//!![BabyCube](../pictures/babycube200_1000.jpg)
//
//!***
//!## Read this before you order parts
//!
//!The motor for the Z-axis has an integrated lead screw: in the *Parts List* the length specified is the length that
//!protrudes from the motor. Some suppliers specify the total length of the lead screw, that is including the part that
//!is inside the motor, so check how your supplier specifies the part before ordering. Another option is to order a motor
//!with a lead screw that is too long and cut to size, not however that lead screws are made from hardened steel and cannot
//!be cut with a hacksaw - an angle grinder is required to cut them.
//!
//!If you wish to use a Raspberry Pi (for running OctoPrint or Klipper),  note that there is not enough space for a full size
//!Raspberry Pi (eg a Pi 4), but the smaller Pi 3A+ or Pi Zero 2W will fit.
//!
//!## Tips for printing the parts
//!
//!Many parts on the BabyCube are designed to press-fit together (a bit like Lego), so the tolerances are quite tight.
//!For this reason it is important you printer is properly calibrated before you print the BabyCube parts. In particular
//!the extruder should be calibrated, the printbed correctly trammed (levelled), and "elephant's foot" compensation set
//!if required.
//!
//!The printed parts can be divided into two classes, the "large parts" (ie the left, right, top and back faces), and the
//!"small parts" (the rest of the parts)
//!
//!I recommend using a 0.6mm nozzle for printing all the parts, but especially the for the large parts.
//!
//!### Parts in proximity to heat sources
//!
//!A number of parts are in proximity with heat sources, namely the hotend, the heated bed and the motors. Ideally these
//!should be printed in ABS, but I have used successfully used PETG.  These parts are insulated from direct contact with
//!the heat sources, by O-rings and cork underlay (for the heated bed) and by cork dampers (for the motors). These
//!insulators should not be omitted from the build.
//!
//!### Small parts
//!
//!For dimensional accuracy the small parts need to be printed with a layer height of 0.25mm and a first layer height of 0.25mm.
//!In particular the **X_Carriage_Belt_Side** and the **X_Carriage_Belt_Tensioner**s must be printed with a layer height of 0.25mm.
//!To maximise part strength, I use the following:
//!
//!1. extrusion width of 0.7mm if using a 0.6mm nozzle, 0.65mm if using a 0.4mm nozzle
//!2. 4 perimeters
//!3. 4 top and bottom layers
//!4. Grid (or honeycomb) infill - not any of the weaker infills (eg Rectangular). 30% infill.
//!
//!### Large parts
//!
//!For the large parts, I use a 0.6mm nozzle with the following settings:
//!
//!1. Layer height 0.5mm, same for first layer height
//!2. Extrusion width of 1.0mm
//!3. 2 perimeters (only 2 needed because of the 1.0mm extrusion width)
//!4. 2 bottom layers (only 2 needed because of the 0.5mm layer height)
//!5. 3 top layers (3 needed because the first layer may be in some parts a bridging layer and so is not full strength,
//!the second and third layers are structural layers).
//!6. Grid infill at 30%. I find that honeycomb infill, although stronger, is more prone to warping. 30% is used to enable
//!the part cooling fan to be switched off (see tips below).
//!7. First layer speed 25mm/s
//!8. If using a standard E3D v6 hotend (ie not a Volcano or other high-volume hotend) set the max volumetric speed to
//!14mm<sup>3</sup>/s for PLA, 11mm<sup>3</sup>/s for ABS, or 8mm<sup>3</sup>/s for PETG
//!
//!The large parts take up almost the full extent of the print bed and as a result can be prone to warping.
//!If you have problems with warping, I suggest the following:
//!
//!1. disable the part cooling fan for the first 10mm (20 layers) or more. The part cooling fan is only really required
//!for the bridges for the motor mounts and switch mounts, since there are no overhangs and the small bolt holes bridge
//!fine without part cooling.
//!2. raise the temperature of the heated bed.
//!3. add a brim
//!
//!## Part substitutions
//!
//! There is some scope for part substitution:
//!
//!1. Generally caphead bolts can be used instead of button head bolts, except on the print head where caphead bolts may interfere
//!with homing.
//!2. I strongly recommend using an aluminium baseplate, but if you have difficulty sourcing this, or cutting it to size, a
//!3D printed baseplate can be used instead.
//!
//!## Configuring the printer
//!
//!There are a number of features that are important to consider when configuring the printer.
//!
//!### Sensorless homing
//!
//!Configuring sensorless homing on the X and Y axes is done in the standard way. Sensorless homing on the Z-axis must
//!be set up to home at the bottom of the Z-axis - so that homing does not cause the print head to crash into the print
//!bed.
//!
//!### Power management
//!
//!The steady state power usage of the BabyCube during printing is about 40W, well within the capabilities of the 120W
//!power supply. However peak power usage must be managed so as not to exceed 120W.
//!
//!1. Use PID temperature control (not bang-bang) for the heated bed. In Marlin this means defining `PIDTEMPBED` in
//!`configuration.h`
//!2. In the printer start gcode in your slicer, do not set all the heating going at once, instead use a phased approach
//!    1. Use `M104 S160` to start the hotend heating without waiting
//!    2. Home the Y axis (note Y axis should be homed before X axis to avoid possible printhead collision with sides)
//!    3. Home the X axis
//!    4. Home the Z axis
//!    5. Use `M400` to wait for the motors to stop
//!    6. Use `M140 S{first_layer_bed_temperature[0]}` to set the first layer bed temperature
//!    7. Use `M109 S{first_layer_temperature[0]}` to set the temperature for nozzle 0 and wait
//!
//!This avoids having all the motors and both heaters on during startup. Once the hotend and heated bed have warmed up,
//!their power usage decreases (since they use PID controllers, and power usage is (mostly) proportional (that's the P in
//! PID) to the difference between the actual heater temperature and the target temperature).
//!
//!Example printer start gcode for Slic3r/PrusaSlicer/SuperSlicer is [here](../../documents/PrinterStart.gcode).
//!Example printer end gcode for is [here](../../documents/PrinterEnd.gcode).
//!
//!### Fans
//!
//!The power supply is 19.5V and the fans specified are 12V. This is handled by setting `FAN_MAX_PWM` to `157` and
//!`EXTRUDER_AUTO_FAN_SPEED` to `150` in `configuration_adv.h`. (`12/19.5*255 = 157`, so setting these values to 157 or
//!less ensures the fans' voltage specification is not exceeded.)
//!
//!### Marlin configuration
//!
//!The changes to `configuration.h` and `configuration_adv.h` are [here](../documents/MarlinConfiguration.md).
//!
//!### Klipper configuration
//!
//!A starting point for the Klipper configuration is [here](../documents/klipper_btt_skr_mini_e3_v2_0.cfg).
//!This only a starting point and should be adjusted according to your components.
//!
//!In particular note that the endstop sensitivities (that is the `driver_SGTHRS` values) must be tuned for each axis.
//!They are currently set at `255`, the most sensitive value and this will need to be reduced as part of the tuning.

include <NopSCADlib/utils/core/core.scad>

use <assemblies/MainAssembly.scad>

//!1. Connect the wiring to the printhead.
//!2. Connect the Bowden tube.
//!3. Add the **Spool_Holder**.
//!4. Calibrate the printer.
module BC200_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC200", big=true) {
    FinalAssembly(test);
}

if ($preview)
    BC200_assembly();
