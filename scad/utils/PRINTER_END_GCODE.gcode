;PRINTER_END_GCODE_begin
G91 ;relative positioning
G1 E-1 F9000  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z0.5 E-4 F900 ;retract the filament some more while lifting the nozzle
G1 Z5 ;z up 5
M140 S0 ;turn off heated bed
M211 S0 ;disable software endstops
G90 ; absolute positioning
G1 X-3 Y2 ;position the hotend to the side of the build volume, so the nozzle does not ooze onto the printed part
M211 S1 ;re-enable software endstops
G91 ; relative positioning
G1 E3 ;de-retract filament so hotend not starved for next print, off bed so OK to ooze here
;M150 B255 ; LED to blue
M400 ;Wait for current moves to finish
M104 S0 ;turn off hotend
G1 Z50 ;z up 50
M84     ;disable motors
;PRINTER_END_GCODE_end
