;PRINTER_START_GCODE_begin
;M150 R255 ;LED to red indicates heating up
M104 S160 ;set hotend temperature to 160 and don't wait
G21 ;set units to millimeters
G90 ;use absolute coordinates for all axes
G28 Y ;home Y
G1 Y2
G28 X ;home X
G1 X-3
G1 F600
G91 ;relative positioning
G1 Z2 ;z up 2
G90 ;absolute positioning
G28 Z ;home Z
G1 Z5
{if filament_type[0]=="PETG"}G92 Z4.95 ;set Z=4.95 for PETG{endif}
G1 Z0.2 ;move nozzle close to bed, so filament does not ooze while hotend is being heated
M400 ;finish moves
M140 S{first_layer_bed_temperature[0]} ;set heated bed temperature and don't wait, do this after homing to reduce peak power requirement
M109 S{first_layer_temperature[0]} ;set temperature for nozzle 0 and wait
G4 P10000 ;wait another 10 seconds for temperature to stabilise
;M150 R255 U255 B255 ;LED to white
G1 Z{layer_height+z_offset} ;set Z height for purge strip
G92 E0 ;reset extruder
M83 ;use relative distances for extrusion
G1 Y42 E10 F1800 ;purge hotend, move 40 mm while extruding, started at Y0
;PRINTER_START_GCODE_end
