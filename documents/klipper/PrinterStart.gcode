;PRINTER_START_GCODE_begin
; ensure PrusaSlicer does not emit temperature commands
M140 S0
M104 S0
SET_PRINT_STATS_INFO TOTAL_LAYER=[total_layer_count]
_START_PRINT EXTRUDER_TEMP={first_layer_temperature[0]} BED_TEMP={first_layer_bed_temperature[0]} FIRST_LAYER_HEIGHT={first_layer_height}
;PRINTER_START_GCODE_end
