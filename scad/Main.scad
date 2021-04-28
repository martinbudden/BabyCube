//!# BabyCube Assembly Instructions
//!
//!These are the assembly instructions for the BabyCube. These instructions are not fully comprehensive, that is they do
//!not show every small detail of the construction and in particular they do not show the wiring. However there is sufficient
//!detail that someone with a good understanding of 3D printers can build the BabyCube.
//!
//!![Main Assembly](assemblies/main_assembled.png)
//!
//!![BabyCube](../pictures/babycube200_1000.jpg)
//!
//!***
//!
//!## Tips for printing the parts
//!
//!The printed parts can be divided into two classes, the "large parts" (ie the left, right, top and back faces), and the
//!"small parts" (the rest of the parts)
//!
//!I recommend using a 0.6mm nozzle for printing all the parts, but especially the for the large parts.
//!
//!### Small parts
//!
//!For dimensional accuracy the small parts need to be printed with a layer height of 0.25mm and a first layer height of 0.25mm.
//!To maximise part strength, I use the following:
//!
//!1. extrusion width of 0.7mm if using a 0.6mm nozzle, 0.65mm if using a 0.4mm nozzle
//!2. 3 perimeters
//!3. 3 top and bottom layers
//!4. Grid (or Honeycomb) infill - not any of the weaker infills (including Rectangular). 30% infill.
//!
//!### Large parts
//!
//!For the large parts, I use a 0.6mm nozzle with the following settings:
//!
//!1. Layer height 0.5mm, same for first layer height
//!2. Extrusion width of 1.0mm
//!3. 2 perimeters (only 2 needed because of the 1.0mm extrusion width)
//!4. 2 top layers (only 2 needed because of the 0.5mm layer height)
//!5. 2 bottom layers
//!6. Grid infill at 30%. I find the honeycomb infill is more prone to warping. 30% is used to enable the part cooling fan
//!to be switched off (see tips below).
//!7. Brim width 3mm
//!8. First layer speed 25mm/s
//!9. If using a standard E3D v6 hotend (ie not a Volcano or other high-volume hotend) set the max volumetric speed to 15mm<sup>3</sup>/s for PLA, 11mm<sup>3</sup>/s for ABS,
//! or 8mm<sup>3</sup>/s for PETG
//!
//!
//!The large parts take up almost the full extent of the print bed and as a result can be prone to warping.
//!If you have problems with warping, I suggest the following:
//!
//!1. disable the part cooling fan for the first 10cm (20 layers) or more. The part cooling fan is only really required for the
//!bridges for the motor mounts and switch mounts, since there are no overhangs and the small bolt holes bridge fine without part
//!cooling.
//!2. raise the temperature of the heated bed.
//!3. increase the width of the brim
//!
//!
//!## Part substitutions
//!
//! There is some scope for part substitution:
//!
//!1. Generally caphead bolts can be used instead of button head bolts, except on the print head where caphead bolts may interfere
//!with homing.
//!2. I strongly recommend using an aluminium baseplate, but if you have difficulty sourcing this, or cutting it to size, a 3D printed
//!baseplate can be used instead.
//!
//!

include <global_defs.scad>
include <NopSCADlib/core.scad>

include <Parameters_Main.scad>

use <MainAssemblies.scad>
use <MainAssembliesCF.scad>

//!1. Connect the wiring to the print head.
//!2. Connect the Bowden tube.
//!3. Add the spool holder.
//!4. Calibrate the printer.
module main_assembly() pose(a = _variant == "BC200CF" ? [55, 0, 25] : [55 + 19, 0, 25 - 15])
assembly("main", big=true) {
    assert(!is_undef(_variant));

    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2])
        if (_variant == "BC200CF")
            FinalAssemblyCF();
        else
            FinalAssembly();
}

if ($preview)
    main_assembly();
