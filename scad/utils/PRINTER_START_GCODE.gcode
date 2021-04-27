; PRINTER_START_GCODE_begin
; Set brush wiping macro
G810 G60 S1 | G1 X245 F6000 | G1 X235 | G1 X245 | G1 R1 | M400 ; store location, wipe, recall location, wait for movement to finish
M150 R255 ; LED to red indicates heating up
M140 S[first_layer_bed_temperature] ; set heated bed temperature and don't wait
M104 S[first_layer_temperature] ; set hotend temperature and don't wait
G21 ; set units to millimeters
G90 ; use absolute coordinates
G28 ; home all axes
; M900 K0.25 ; linear advance
M420 S1 ; set mesh bed leveling
G1 Z5 F5000 ; lift nozzle
G1 X10 Y5
G1 Z0.05 ; move nozzle close to bed
M109 S[first_layer_temperature] ; set temperature and wait
; G4 P120000 ; wait another 120 seconds for nozzle length to stabilise
G4 P20000 ; wait another 20 seconds for nozzle length to stabilise
M150 R255 U255 B255 ; LED to white
G92 E0 ; reset extruder
M83 ; use relative distances for extrusion
G1 Z0.25
G1 X130 E25 ; purge hotend, move 120 mm while extruding, started at X10
G1 E-2  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z0.5 E-5; lift nozzle a bit and retract more filament
G1 X140 E7 ; push back some of the retracted filament ready to start print
; PRINTER_START_GCODE_end
