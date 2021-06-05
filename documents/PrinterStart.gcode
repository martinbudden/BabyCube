; PRINTER_START_GCODE_begin
M104 S160 ; set hotend temperature to 160 and don't wait
G21 ; set units to millimeters
G90 ; use absolute coordinates for all axes
;G28 ; home all axes
G28 X ; home X
G1 X5
G28 X ; home X
G1 X1
G28 Y ; home Y
G1 Y5
G28 Y ; home Y
G1 Y1
G1 F600
G28 Z ; home Z
G91 ; relative positioning
G1 Z5 ; z up 5
G90 ; absolute positioning
G28 Z ; home Z
G1 Z5
G1 X2 Y2
G1 Z0.1 ; move nozzle close to bed, so filament does not ooze while hotend is being heated
M400 ; finish moves
M140 S{first_layer_bed_temperature[0]} ; set heated bed temperature and don't wait, do this after homing to reduce peak power requirement
M109 S{first_layer_temperature[0]} ; set temperature for nozzle 0 and wait
G4 P10000 ; wait another 10 seconds for temperature to stabilise
G92 E0 ; reset extruder
G1 Z{layer_height} ; start setting Z height for purge strip
G91 ; use relative coordinates for all axes
G1 Z{z_offset} ; raise the hotend by z_offset
G90 ; use absolute coordinates for all axes
M83 ; use relative distances for extrusion
G1 X45 E5 F1800; purge hotend, move 50 mm while extruding, started at X0
G1 X95 E-2; move another 40mm, to allow any compressed filament to exit nozzle, so it doesn't form a blob later
; PRINTER_START_GCODE_end
