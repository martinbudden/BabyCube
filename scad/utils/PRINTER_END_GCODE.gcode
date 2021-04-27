; PRINTER_END_GCODE_begin
G91 ; relative positioning
G1 E-2 F300  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+0.5 E-8 X-20 Y-20 F9000 ;move Z up a bit and retract filament even more
G1 Z50 ; z up 50
M104 S0 ; turn off hotend
M140 S0 ; turn off heated bed
M150 B255 ; LED to blue
G90 ; absolute positioning
G28 X0  ; home X axis
M84     ; disable motors
; PRINTER_END_GCODE_end
