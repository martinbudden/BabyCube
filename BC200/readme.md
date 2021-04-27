<a name="TOP"></a>

# BabyCube Assembly Instructions

![Main Assembly](assemblies/main_assembled.png)

![BabyCube](../pictures/babycube200_1000.jpg)


<span></span>

---

## Table of Contents

1. [Parts list](#Parts_list)

1. [X Carriage Assembly](#X_Carriage_assembly)
1. [Print Head Assembly](#Print_head_assembly)
1. [X Carriage Front Assembly](#X_Carriage_Front_assembly)
1. [Top Face Stage 1 Assembly](#Top_Face_Stage_1_assembly)
1. [Top Face Stage 2 Assembly](#Top_Face_Stage_2_assembly)
1. [Top Face Assembly](#Top_Face_assembly)
1. [Display Cover Assembly](#Display_Cover_assembly)
1. [Display Housing Assembly](#Display_Housing_assembly)
1. [Z Carriage Assembly](#Z_Carriage_assembly)
1. [Print Bed Assembly](#Print_bed_assembly)
1. [Back Face Stage 1 Assembly](#Back_Face_Stage_1_assembly)
1. [Back Face Assembly](#Back_Face_assembly)
1. [Right Face Stage 1 Assembly](#Right_Face_Stage_1_assembly)
1. [Right Face Assembly](#Right_Face_assembly)
1. [Base Assembly](#Base_assembly)
1. [Switch Shroud Assembly](#Switch_Shroud_assembly)
1. [Left Face Assembly](#Left_Face_assembly)
1. [Stage 1 Assembly](#Stage_1_assembly)
1. [Stage 2 Assembly](#Stage_2_assembly)
1. [Stage 3 Assembly](#Stage_3_assembly)
1. [Stage 4 Assembly](#Stage_4_assembly)
1. [Stage 5 Assembly](#Stage_5_assembly)
1. [Stage 6 Assembly](#Stage_6_assembly)
1. [Main Assembly](#main_assembly)


## Tips for printing the parts

The printed parts can be divided into two classes, the "large parts" (ie the left, right, top and back faces), and the
"small parts" (the rest of the parts)

I recommend using a 0.6mm nozzle for printing all the parts, but especially the for the large parts.

### Small parts

For dimensional accuracy the small parts need to be printed with a layer height of 0.25mm and a first layer height of 0.25mm.
To maximise part strength, I use the following:

1. extrusion width of 0.7mm if using a 0.6mm nozzle, 0.65mm if using a 0.4mm nozzle
2. 3 perimeters
3. 3 top and bottom layers
4. Grid (or Honeycomb) infill - not any of the weaker infills (including Rectangular). 30% infill.

### Large parts

For the large parts, I use a 0.6mm nozzle with the following settings:

1. Layer height 0.5mm, same for first layer height
2. Extrusion width of 1.0mm
3. 2 perimeters (only 2 needed because of the 1.0mm extrusion width)
4. 2 top layers (only 2 needed because of the 0.5mm layer height)
5. 2 bottom layers
6. Grid infill at 30%. I find the honeycomb infill is more prone to warping. 30% is used to enable the part cooling fan
to be switched off (see tips below).
7. Brim width 3mm
8. First layer speed 25mm/s
9. If using a standard E3D v6 hotend (ie not a Volcano or other high-volume hotend) set the max volumetric speed to 15mm<sup>3</sup>/s for PLA, 11mm<sup>3</sup>/s for ABS,
or 8mm<sup>3</sup>/s for PETG


The large parts take up almost the full extent of the print bed and as a result can be prone to warping.
If you have problems with warping, I suggest the following:

1. disable the part cooling fan for the first 10cm (20 layers) or more. The part cooling fan is only really required for the
bridges for the motor mounts and switch mounts, since there are no overhangs and the small bolt holes bridge fine without part
cooling.
2. raise the temperature of the heated bed.
3. increase the width of the brim


## Part substitutions

There is some scope for part substitution:

1. Generally caphead bolts can be used instead of button head bolts, except on the print head where caphead bolts may interfere
with homing.
2. I strongly recommend using an aluminium baseplate, but if you have difficulty sourcing this, or cutting it to size, a 3D printed
baseplate can be used instead.



<span></span>
[Top](#TOP)

---
<a name="Parts_list"></a>

## Parts list


| <span style="writing-mode: vertical-rl; text-orientation: mixed;">Print Head</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">X Carriage Front</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Top Face</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Display Housing</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Print Bed</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Back Face</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Right Face</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Base</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Left Face</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">Main</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">TOTALS</span> |  |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|:---|
|  |  |  |  |  |  |  |  |  |  | | **Vitamins** |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Aluminium rectangular box section 12mm x 8mm x 1mm, length 85mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Aluminium sheet 220mm x 204mm x 3mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Belt GT2 x 6mm x 728mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Belt GT2 x 6mm x 728mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; BigTreeTech SKR Mini E3 v2.0 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; BigTreeTech TFT35 v3.0 |
| &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; Bolt M2 caphead x  6mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 buttonhead x  8mm |
| &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;6&nbsp; |  &nbsp;&nbsp;17&nbsp; | &nbsp;&nbsp; Bolt M3 buttonhead x 10mm |
| &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;24&nbsp; |  &nbsp;&nbsp;38&nbsp; | &nbsp;&nbsp; Bolt M3 buttonhead x 12mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; Bolt M3 buttonhead x 16mm |
| &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 buttonhead x 25mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;9&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x  6mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;26&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;35&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x  8mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x 10mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x 16mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x 20mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 caphead x 25mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;6&nbsp; |  &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp; Bolt M3 countersunk x  6mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;12&nbsp; |  &nbsp;&nbsp;14&nbsp; | &nbsp;&nbsp; Bolt M3 countersunk x 10mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 countersunk x 12mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp; Bolt M3 countersunk x 16mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Bolt M3 countersunk x 30mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp; Bolt M5 countersunk x 16mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Cork damper NEMA 14 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Cork damper NEMA 17 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Cork underlay 105mm x 105mm x 3mm |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; E3D V6 Fan Duct |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Fan 30mm x 10mm |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Hot end E3D V6 direct 1.75mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Leadscrew 8mm x 150mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Leadscrew nut 8 x 2 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Linear bearing LM12LUU |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Linear rail MGN9 x 150mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Linear rail MGN9 x 200mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp; Linear rail carriage MGN9C |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Linear rod 12mm x 200mm |
| &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; M3 self tapping screw x 16mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; MK10 Dual Pulley Extruder |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Magnetic base 100mm x 100mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp; Nut M5 nyloc |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; O-ring nitrile 3mm x 2mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; OpenBuilds mini heated bed 100mm x 100mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; PTFE tube 229 mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp; Pillar hex nylon F/F M3x12 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Print surface 100mm x 100mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp; Pulley GT2 idler 16 teeth |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Pulley GT2 idler smooth 9.63mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Pulley GT2UM 20 teeth |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Rocker Switch PRASA1-16F-BB0BW |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; SK12 shaft support bracket |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Spiral wrap, 500mm |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Square radial fan 3010 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Stepper motor NEMA14 x 36mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Stepper motor NEMA17 x 34mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Stepper motor NEMA17 x 40mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Stepper motor cable, 150mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp; Stepper motor cable, 400mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;18&nbsp; | &nbsp;&nbsp; Washer  M3 |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Wire black 12SWG, length 100mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Wire red 12SWG, length 100mm |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; XT60 Connector Female |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; XT60 Connector Male |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;13&nbsp; | &nbsp;&nbsp; Ziptie 2.5mm x 100mm min length |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp; Ziptie 2.5mm x 100mm min length |
| &nbsp;&nbsp;19&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;54&nbsp; | &nbsp;&nbsp;13&nbsp; | &nbsp;&nbsp;21&nbsp; | &nbsp;&nbsp;30&nbsp; | &nbsp;&nbsp;26&nbsp; | &nbsp;&nbsp;20&nbsp; | &nbsp;&nbsp;34&nbsp; | &nbsp;&nbsp;58&nbsp; | &nbsp;&nbsp;281&nbsp; | &nbsp;&nbsp;Total vitamins count |
|  |  |  |  |  |  |  |  |  |  | | **3D printed parts** |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Back_Face.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Base.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Base_Template.stl |
| &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;Belt_Clamp.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;Belt_Tensioner.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Belt_Tidy.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Display_Housing.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Display_Housing_Bracket.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Fan_Duct.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;4&nbsp; |  &nbsp;&nbsp;4&nbsp; | &nbsp;&nbsp;Foot_LShaped_8mm.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Front_Lower_Chord.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Front_Upper_Chord.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Hotend_Clamp.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Hotend_Strain_Relief_Clamp.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Left_Face.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;PSU_Bracket.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp;PSU_Support.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Right_Face.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Spool_Holder.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Switch_Shroud.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Switch_Shroud_Clamp.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Top_Face.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;X_Carriage.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;X_Carriage_Front.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Y_Carriage_Brace_Left.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Y_Carriage_Brace_Right.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Y_Carriage_Left.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Y_Carriage_Right.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Z_Carriage.stl |
| &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp;6&nbsp; | &nbsp;&nbsp;37&nbsp; | &nbsp;&nbsp;Total 3D printed parts count |
|  |  |  |  |  |  |  |  |  |  | | **CNC routed parts** |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;BaseAL.dxf |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;Total CNC routed parts count |

<span></span>
[Top](#TOP)

---
<a name="X_Carriage_assembly"></a>

## X Carriage Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M2 caphead x  6mm|
|4| Bolt M3 buttonhead x 10mm|
|1| Square radial fan 3010|
|1| Ziptie 2.5mm x 100mm min length|


### 3D Printed parts

| 2 x Belt_Clamp.stl | 1 x Fan_Duct.stl | 1 x X_Carriage.stl |
|---|---|---|
| ![Belt_Clamp.stl](stls/Belt_Clamp.png) | ![Fan_Duct.stl](stls/Fan_Duct.png) | ![X_Carriage.stl](stls/X_Carriage.png) 



### Assembly instructions

![X_Carriage_assembly](assemblies/X_Carriage_assembly.png)

1. Bolt the belt clamps to the sides of the X_Carriage. Leave the clamps loose to allow later insertion of the belts.
2. Bolt the fan onto the side of the X_Carriage, secure the fan wire with a ziptie.
3. Ensure a good fit between the fan and the fan duct and bolt the fan duct to the X_Carriage.

![X_Carriage_assembled](assemblies/X_Carriage_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Print_head_assembly"></a>

## Print Head Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|2| Bolt M3 buttonhead x 12mm|
|2| Bolt M3 buttonhead x 25mm|
|1| E3D V6 Fan Duct|
|1| Fan 30mm x 10mm|
|1| Hot end E3D V6 direct 1.75mm|
|2| M3 self tapping screw x 16mm|


### 3D Printed parts

| 1 x Hotend_Clamp.stl | 1 x Hotend_Strain_Relief_Clamp.stl |
|---|---|
| ![Hotend_Clamp.stl](stls/Hotend_Clamp.png) | ![Hotend_Strain_Relief_Clamp.stl](stls/Hotend_Strain_Relief_Clamp.png) 



### Sub-assemblies

| 1 x X_Carriage_assembly |
|---|
| ![X_Carriage_assembled](assemblies/X_Carriage_assembled_tn.png) 



### Assembly instructions

![Print_head_assembly](assemblies/Print_head_assembly.png)


Note that wiring is not shown in this diagram.

1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
2. Use the Hotend_Clamp to attach the hotend to the X_Carriage.
3. Collect the wires together and attach to the X_Carriage using the Hotend_Strain_Relief_Clamp.

![Print_head_assembled](assemblies/Print_head_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="X_Carriage_Front_assembly"></a>

## X Carriage Front Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 buttonhead x 10mm|
|2| Bolt M3 caphead x 20mm|


### 3D Printed parts

| 2 x Belt_Clamp.stl | 2 x Belt_Tensioner.stl | 1 x Belt_Tidy.stl |
|---|---|---|
| ![Belt_Clamp.stl](stls/Belt_Clamp.png) | ![Belt_Tensioner.stl](stls/Belt_Tensioner.png) | ![Belt_Tidy.stl](stls/Belt_Tidy.png) 


| 1 x X_Carriage_Front.stl |
|---|
| ![X_Carriage_Front.stl](stls/X_Carriage_Front.png) 



### Assembly instructions

![X_Carriage_Front_assembly](assemblies/X_Carriage_Front_assembly.png)


1. Bolt the Belt_Clamps to the X_Carriage_Front, leaving them loose for later insertion of the belts.
2. Insert the Belt_tensioners into the X_Carriage_Front, and use the 20mm bolts to secure them in place.

![X_Carriage_Front_assembled](assemblies/X_Carriage_Front_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Top_Face_Stage_1_assembly"></a>

## Top Face Stage 1 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|18| Bolt M3 caphead x  8mm|
|2| Bolt M3 countersunk x 10mm|
|2| Linear rail MGN9 x 200mm|
|2| Linear rail carriage MGN9C|


### 3D Printed parts

| 1 x Top_Face.stl |
|---|
| ![Top_Face.stl](stls/Top_Face.png) 



### Assembly instructions

![Top_Face_Stage_1_assembly](assemblies/Top_Face_Stage_1_assembly.png)

1. Turn the Top_Face upside down and place it on a flat surface.
2. Bolt the rails to the top face. Note that the first and last bolts on the left rail are countersunk bolts and act as pilot bolts to ensure the rails are aligned precisely - they should be tightened before all the other bolts on the left side.
3. The bolts on the right side rail should be only loosely tightened - they will be fully tightened when the right rail is aligned when the X axis rail is added.

![Top_Face_Stage_1_assembled](assemblies/Top_Face_Stage_1_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Top_Face_Stage_2_assembly"></a>

## Top Face Stage 2 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|8| Bolt M3 caphead x  8mm|
|4| Bolt M3 caphead x 16mm|
|2| Bolt M3 caphead x 25mm|
|2| Pulley GT2 idler 16 teeth|
|2| Pulley GT2 idler smooth 9.63mm|
|6| Washer  M3|


### 3D Printed parts

| 1 x Y_Carriage_Brace_Left.stl | 1 x Y_Carriage_Brace_Right.stl | 1 x Y_Carriage_Left.stl |
|---|---|---|
| ![Y_Carriage_Brace_Left.stl](stls/Y_Carriage_Brace_Left.png) | ![Y_Carriage_Brace_Right.stl](stls/Y_Carriage_Brace_Right.png) | ![Y_Carriage_Left.stl](stls/Y_Carriage_Left.png) 


| 1 x Y_Carriage_Right.stl |
|---|
| ![Y_Carriage_Right.stl](stls/Y_Carriage_Right.png) 



### Sub-assemblies

| 1 x Top_Face_Stage_1_assembly |
|---|
| ![Top_Face_Stage_1_assembled](assemblies/Top_Face_Stage_1_assembled_tn.png) 



### Assembly instructions

![Top_Face_Stage_2_assembly](assemblies/Top_Face_Stage_2_assembly.png)

Attach the left and right Y carriages to the top face rails. Note that the two carriages are not interchangeable so be sure
to attach them as shown in the diagram.

The carriages should be attached to the rails before the pulleys are added, since otherwise the bolts are not accessible.  
Attach the pulleys to the carriages. Note that the toothless pulleys are on the inside. Note also that there is a washer under
each pulley, but not on top of the each pulley.

Tighten the pulley bolts until the pulleys stop running freely, and then loosen them slightly (approximately 1/16 of a turn)
so they run freely.


![Top_Face_Stage_2_assembled](assemblies/Top_Face_Stage_2_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Top_Face_assembly"></a>

## Top Face Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 caphead x 10mm|
|1| Linear rail MGN9 x 150mm|
|1| Linear rail carriage MGN9C|


### Sub-assemblies

| 1 x Top_Face_Stage_2_assembly |
|---|
| ![Top_Face_Stage_2_assembled](assemblies/Top_Face_Stage_2_assembled_tn.png) 



### Assembly instructions

![Top_Face_assembly](assemblies/Top_Face_assembly.png)

1. Turn the Top_Face into its normal orientation.
2. Bolt the X-axis linear rail onto the Y carriages.
3. Turn the Top_Face upside down again and place it on a flat surface.
4. Align the left and right Y-axis linear rails. Do this by pushing the X-axis rail to the rear of the top face and tighten
the corresponding bolts (left loose in a previous step) and then push the X-axis rails to the front of the top face, again
tightening the corresponding bolts.
5. Check that the carriages run smoothly on the Y-axis linear rails.


![Top_Face_assembled](assemblies/Top_Face_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Display_Cover_assembly"></a>

## Display Cover Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| BigTreeTech TFT35 v3.0|
|4| Bolt M3 caphead x  6mm|


### 3D Printed parts

| 1 x Display_Housing.stl |
|---|
| ![Display_Housing.stl](stls/Display_Housing.png) 



### Assembly instructions

![Display_Cover_assembly](assemblies/Display_Cover_assembly.png)

Place the display into the housing and secure it with the bolts - use the bolts to self-tap the holes in the housing.
Attach the knob to the display.

![Display_Cover_assembled](assemblies/Display_Cover_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Display_Housing_assembly"></a>

## Display Housing Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 buttonhead x 16mm|
|4| Bolt M3 caphead x 16mm|


### 3D Printed parts

| 1 x Display_Housing_Bracket.stl | 1 x Front_Lower_Chord.stl |
|---|---|
| ![Display_Housing_Bracket.stl](stls/Display_Housing_Bracket.png) | ![Front_Lower_Chord.stl](stls/Front_Lower_Chord.png) 



### Sub-assemblies

| 1 x Display_Cover_assembly |
|---|
| ![Display_Cover_assembled](assemblies/Display_Cover_assembled_tn.png) 



### Assembly instructions

![Display_Housing_assembly](assemblies/Display_Housing_assembly.png)

1. Bolt the Display_Cover_assembly to the Display_Housing_Bracket.
2. Bolt the Display_Housing_Bracket to the Front_Lower_Chord.

![Display_Housing_assembled](assemblies/Display_Housing_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Z_Carriage_assembly"></a>

## Z Carriage Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 caphead x  8mm|
|1| Leadscrew nut 8 x 2|
|2| Linear bearing LM12LUU|


### 3D Printed parts

| 1 x Z_Carriage.stl |
|---|
| ![Z_Carriage.stl](stls/Z_Carriage.png) 



### Assembly instructions

![Z_Carriage_assembly](assemblies/Z_Carriage_assembly.png)

Slide the linear bearings into the Z Carriage.

Affix the leadscrew nut.

![Z_Carriage_assembled](assemblies/Z_Carriage_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Print_bed_assembly"></a>

## Print Bed Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 countersunk x 16mm|
|1| Cork underlay 105mm x 105mm x 3mm|
|1| Magnetic base 100mm x 100mm|
|4| O-ring nitrile 3mm x 2mm|
|1| OpenBuilds mini heated bed 100mm x 100mm|
|1| Print surface 100mm x 100mm|
|2| Ziptie 2.5mm x 100mm min length|


### Sub-assemblies

| 1 x Z_Carriage_assembly |
|---|
| ![Z_Carriage_assembled](assemblies/Z_Carriage_assembled_tn.png) 



### Assembly instructions

![Print_bed_assembly](assemblies/Print_bed_assembly.png)

1. Prepare the the cork underlay by cutting it to size, making a cutout for the heated bed wiring, and drilling holes for the bolts.
2. Prepare the heated bed by soldering on the wires and sticking on the magnetic base. Drill bolt holes in the magnetic base.
3. Place the cork underlay on the Z_Carriage and place the heated bed on top.
4. Secure the heated bed to the Z_Carriage, using the bolts and O-rings. Note that the O-rings help thermally insulate the heated bed from the Z_Carriage.

![Print_bed_assembled](assemblies/Print_bed_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Back_Face_Stage_1_assembly"></a>

## Back Face Stage 1 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 buttonhead x 12mm|
|8| Bolt M5 countersunk x 16mm|
|1| Cork damper NEMA 17|
|1| Leadscrew 8mm x 150mm|
|8| Nut M5 nyloc|
|4| SK12 shaft support bracket|
|1| Stepper motor NEMA17 x 34mm|
|1| Stepper motor cable, 150mm|


### 3D Printed parts

| 1 x Back_Face.stl |
|---|
| ![Back_Face.stl](stls/Back_Face.png) 



### Assembly instructions

![Back_Face_Stage_1_assembly](assemblies/Back_Face_Stage_1_assembly.png)

1. Attach the SK brackets to the back face. Note the orientation of the bolts: the top grub screws should face inward and the bottom grub screws should face outward. This allows access after the BabyCube is fully assembled.
2. Place the cork damper on the stepper motor and attach the stepper motor to the back face. Note the orientation of the JST socket.

![Back_Face_Stage_1_assembled](assemblies/Back_Face_Stage_1_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Back_Face_assembly"></a>

## Back Face Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|2| Linear rod 12mm x 200mm|


### Sub-assemblies

| 1 x Back_Face_Stage_1_assembly | 1 x Print_bed_assembly |
|---|---|
| ![Back_Face_Stage_1_assembled](assemblies/Back_Face_Stage_1_assembled_tn.png) | ![Print_bed_assembled](assemblies/Print_bed_assembled_tn.png) 



### Assembly instructions

![Back_Face_assembly](assemblies/Back_Face_assembly.png)

Slide the linear rods through the SK brackets and the printbed bearings.
Tighten the bolts in the SK brackets, ensuring the Z_Carriage slides freely on the rods.


![Back_Face_assembled](assemblies/Back_Face_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Right_Face_Stage_1_assembly"></a>

## Right Face Stage 1 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 buttonhead x 12mm|
|1| Bolt M3 countersunk x 30mm|
|1| Cork damper NEMA 14|
|2| Pulley GT2 idler 16 teeth|
|1| Pulley GT2UM 20 teeth|
|1| Stepper motor NEMA14 x 36mm|
|1| Stepper motor cable, 400mm|
|6| Washer  M3|
|3| Ziptie 2.5mm x 100mm min length|


### 3D Printed parts

| 1 x Right_Face.stl |
|---|
| ![Right_Face.stl](stls/Right_Face.png) 



### Assembly instructions

![Right_Face_Stage_1_assembly](assemblies/Right_Face_Stage_1_assembly.png)

1. Place the cork damper on the stepper motor and attach the motor to the frame.
2. Attach the toothed idler pulleys to the frame, separated by the washers as shown.
3. Thread the zip ties through the frame, but do not tighten them yet, since the extruder motor cable will also go through the zip ties.

![Right_Face_Stage_1_assembled](assemblies/Right_Face_Stage_1_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Right_Face_assembly"></a>

## Right Face Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Cork damper NEMA 17|
|1| MK10 Dual Pulley Extruder|
|1| Stepper motor NEMA17 x 40mm|
|1| Stepper motor cable, 400mm|
|2| Ziptie 2.5mm x 100mm min length|


### Sub-assemblies

| 1 x Right_Face_Stage_1_assembly |
|---|
| ![Right_Face_Stage_1_assembled](assemblies/Right_Face_Stage_1_assembled_tn.png) 



### Assembly instructions

![Right_Face_assembly](assemblies/Right_Face_assembly.png)

1. Attach the extruder gear to the stepper motor.
2. Place the cork damper on the stepper motor and attach the motor through the frame to the extruder.
3. Secure the cables for both motors with the zip ties.

![Right_Face_assembled](assemblies/Right_Face_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Base_assembly"></a>

## Base Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Aluminium rectangular box section 12mm x 8mm x 1mm, length 85mm|
|1| Aluminium sheet 220mm x 204mm x 3mm|
|1| BigTreeTech SKR Mini E3 v2.0|
|2| Bolt M3 buttonhead x 10mm|
|5| Bolt M3 caphead x  6mm|
|5| Bolt M3 caphead x  8mm|
|5| Pillar hex nylon F/F M3x12|


### 3D Printed parts

| 1 x Base.stl | 1 x Base_Template.stl | 1 x PSU_Bracket.stl |
|---|---|---|
| ![Base.stl](stls/Base.png) | ![Base_Template.stl](stls/Base_Template.png) | ![PSU_Bracket.stl](stls/PSU_Bracket.png) 


| 2 x PSU_Support.stl |
|---|
| ![PSU_Support.stl](stls/PSU_Support.png) 



### CNC Routed parts

| 1 x BaseAL.dxf |
|---|
| ![BaseAL.dxf](dxfs/BaseAL.png) 



### Assembly instructions

![Base_assembly](assemblies/Base_assembly.png)

1. Attach the Base_Template to the aluminium sheet and use it to drill out the holes. The base template has 2mm holes marked out for a pilot hole.
Once you have drilled these re-drill the holes with a 3mm bit. Note that the Base_Template has holes marked for the BTT E3 Mini V2, the BTT E3 Turbo and the BTT STL 1.4 boards - choose the appropriate holes for your board.
2. Attach the PSU_Supports to the base plate with double sided tape.
3. Bolt the PSU_Bracket to the base plate.
4. Attach the PSU to the base plate with the velcro straps.
5. Cover the top and bottom sides of the box section with thermal paste.
6. Attach the box section to the bottom of the control board with electrical tape. The tape serves to keep the box section in place until it is attached to the base plate.
7. Using the hex pillars, attach the control board to the base plate.


![Base_assembled](assemblies/Base_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Switch_Shroud_assembly"></a>

## Switch Shroud Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Bolt M3 buttonhead x 10mm|
|2| Wire black 12SWG, length 100mm|
|2| Wire red 12SWG, length 100mm|
|1| XT60 Connector Female|
|1| XT60 Connector Male|


### 3D Printed parts

| 1 x Switch_Shroud.stl | 1 x Switch_Shroud_Clamp.stl |
|---|---|
| ![Switch_Shroud.stl](stls/Switch_Shroud.png) | ![Switch_Shroud_Clamp.stl](stls/Switch_Shroud_Clamp.png) 



### Assembly instructions

![Switch_Shroud_assembly](assemblies/Switch_Shroud_assembly.png)

1. Place the XT60 connectors through the Switch_Shroud and use the Switch_Shroud_Clamp to keep them in place.

![Switch_Shroud_assembled](assemblies/Switch_Shroud_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Left_Face_assembly"></a>

## Left Face Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|4| Bolt M3 buttonhead x 12mm|
|2| Bolt M3 countersunk x 12mm|
|2| Bolt M3 countersunk x 16mm|
|1| Bolt M3 countersunk x 30mm|
|1| Cork damper NEMA 14|
|2| Pulley GT2 idler 16 teeth|
|1| Pulley GT2UM 20 teeth|
|1| Rocker Switch PRASA1-16F-BB0BW|
|1| Stepper motor NEMA14 x 36mm|
|1| Stepper motor cable, 400mm|
|6| Washer  M3|
|5| Ziptie 2.5mm x 100mm min length|


### 3D Printed parts

| 1 x Left_Face.stl |
|---|
| ![Left_Face.stl](stls/Left_Face.png) 



### Sub-assemblies

| 1 x Switch_Shroud_assembly |
|---|
| ![Switch_Shroud_assembled](assemblies/Switch_Shroud_assembled_tn.png) 



### Assembly instructions

![Left_Face_assembly](assemblies/Left_Face_assembly.png)


1. Bolt the motor to the left face. Note orientation of the JST connector.
2. Secure the motor wires with zip ties.
3. Bolt the two front idler pulleys with washers to the frame.
4. Attach the wires to the switch and bolt the switch shroud to the left face.

![Left_Face_assembled](assemblies/Left_Face_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_1_assembly"></a>

## Stage 1 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Bolt M3 buttonhead x  8mm|
|4| Bolt M3 buttonhead x 12mm|


### 3D Printed parts

| 2 x Foot_LShaped_8mm.stl |
|---|
| ![Foot_LShaped_8mm.stl](stls/Foot_LShaped_8mm.png) 



### Sub-assemblies

| 1 x Base_assembly | 1 x Left_Face_assembly |
|---|---|
| ![Base_assembled](assemblies/Base_assembled_tn.png) | ![Left_Face_assembled](assemblies/Left_Face_assembled_tn.png) 



### Assembly instructions

![Stage_1_assembly](assemblies/Stage_1_assembly.png)

Bolt the left face and the left feet to the base


![Stage_1_assembled](assemblies/Stage_1_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_2_assembly"></a>

## Stage 2 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Bolt M3 buttonhead x  8mm|
|4| Bolt M3 buttonhead x 12mm|


### 3D Printed parts

| 2 x Foot_LShaped_8mm.stl |
|---|
| ![Foot_LShaped_8mm.stl](stls/Foot_LShaped_8mm.png) 



### Sub-assemblies

| 1 x Right_Face_assembly | 1 x Stage_1_assembly |
|---|---|
| ![Right_Face_assembled](assemblies/Right_Face_assembled_tn.png) | ![Stage_1_assembled](assemblies/Stage_1_assembled_tn.png) 



### Assembly instructions

![Stage_2_assembly](assemblies/Stage_2_assembly.png)

Bolt the right face and the right feet to the base


![Stage_2_assembled](assemblies/Stage_2_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_3_assembly"></a>

## Stage 3 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|2| Bolt M3 buttonhead x 10mm|
|6| Bolt M3 countersunk x  6mm|
|4| Bolt M3 countersunk x 10mm|
|4| Ziptie 2.5mm x 100mm min length|


### Sub-assemblies

| 1 x Back_Face_assembly | 1 x Stage_2_assembly |
|---|---|
| ![Back_Face_assembled](assemblies/Back_Face_assembled_tn.png) | ![Stage_2_assembled](assemblies/Stage_2_assembled_tn.png) 



### Assembly instructions

![Stage_3_assembly](assemblies/Stage_3_assembly.png)


Add the back face and bolt it to the left and right faces and the base.


![Stage_3_assembled](assemblies/Stage_3_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_4_assembly"></a>

## Stage 4 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|2| Bolt M3 buttonhead x 10mm|
|8| Bolt M3 countersunk x 10mm|


### 3D Printed parts

| 1 x Front_Upper_Chord.stl |
|---|
| ![Front_Upper_Chord.stl](stls/Front_Upper_Chord.png) 



### Sub-assemblies

| 1 x Display_Housing_assembly | 1 x Stage_3_assembly |
|---|---|
| ![Display_Housing_assembled](assemblies/Display_Housing_assembled_tn.png) | ![Stage_3_assembled](assemblies/Stage_3_assembled_tn.png) 



### Assembly instructions

![Stage_4_assembly](assemblies/Stage_4_assembly.png)


Bolt the BabyCube nameplate and the display housing to the front of the frame.


![Stage_4_assembled](assemblies/Stage_4_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_5_assembly"></a>

## Stage 5 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|10| Bolt M3 buttonhead x 12mm|


### Sub-assemblies

| 1 x Stage_4_assembly | 1 x Top_Face_assembly |
|---|---|
| ![Stage_4_assembled](assemblies/Stage_4_assembled_tn.png) | ![Top_Face_assembled](assemblies/Top_Face_assembled_tn.png) 



### Assembly instructions

![Stage_5_assembly](assemblies/Stage_5_assembly.png)


Add the Top Face.


![Stage_5_assembled](assemblies/Stage_5_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="Stage_6_assembly"></a>

## Stage 6 Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| Belt GT2 x 6mm x 728mm|
|1| Belt GT2 x 6mm x 728mm|
|2| Bolt M3 buttonhead x 10mm|
|6| Bolt M3 buttonhead x 12mm|
|1| Spiral wrap, 500mm|


### Sub-assemblies

| 1 x Print_head_assembly | 1 x Stage_5_assembly | 1 x X_Carriage_Front_assembly |
|---|---|---|
| ![Print_head_assembled](assemblies/Print_head_assembled_tn.png) | ![Stage_5_assembled](assemblies/Stage_5_assembled_tn.png) | ![X_Carriage_Front_assembled](assemblies/X_Carriage_Front_assembled_tn.png) 



### Assembly instructions

![Stage_6_assembly](assemblies/Stage_6_assembly.png)


1. Add the printhead.
2. Thread the the bolts in the pattern shown.
3. Adjust the belts tension.

![Stage_6_assembled](assemblies/Stage_6_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="main_assembly"></a>

## Main Assembly

### Vitamins

|Qty|Description|
|---:|:----------|
|1| PTFE tube 229 mm|


### 3D Printed parts

| 1 x Spool_Holder.stl |
|---|
| ![Spool_Holder.stl](stls/Spool_Holder.png) 



### Sub-assemblies

| 1 x Stage_6_assembly |
|---|
| ![Stage_6_assembled](assemblies/Stage_6_assembled_tn.png) 



### Assembly instructions

![main_assembly](assemblies/main_assembly.png)

1. Connect the wiring to the print head.
2. Connect the Bowden tube.
3. Add the spool holder.
4. Calibrate the printer.

![main_assembled](assemblies/main_assembled.png)

<span></span>
[Top](#TOP)
