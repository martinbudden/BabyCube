;PRINTER_END_GCODE_begin
G91 ;relative positioning
G1 E-1 F9000  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z0.5 E-4 F900
G1 Z5 ;z up 5
M140 S0 ;turn off heated bed
G90 ;absolute positioning
G1 X-3 Y2
{if layer_z < max_print_height - 4}G1 Z{max_print_height - 4}{endif}
M83 ;use relative distances for extrusion
G1 E3 ;deretract filament so hotend not starved for next print, off bed so OK to ooze here
M400 ;Wait for current moves to finish
M104 S0 ;turn off hotend
M84 ;disable motors
;PRINTER_END_GCODE_end
