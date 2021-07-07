; PRINTER_END_GCODE_begin
G91 ; relative positioning
G1 E-1 F9000  ; retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z0.5 E-1 F900 ; lift nozzle and retract
M400 ; Wait for current moves to finish
M104 S0 ; turn off hotend
M140 S0 ; turn off heated bed
G1 Z50 ; z up 50
G90 ; absolute positioning
G1 X5 Y 5 ; position near origin
M84 ; disable motors
; PRINTER_END_GCODE_end
