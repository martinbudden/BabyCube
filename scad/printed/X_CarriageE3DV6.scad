include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

include <../utils/carriageTypes.scad>

include <../utils/PrintheadOffsets.scad>

include <PrintheadE3DV6.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>
use <X_CarriageFanDuct.scad>

function xCarriageHotendSideSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 4.5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];
//function xCarriageHotendOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageHotendSideSize(xCarriageType).y + 0.5;

//!!TODO - change hotendOffset.z to 1.5 for new X_Carriage with belt attachments
function hotendOffset(xCarriageType, hotendDescriptor="E3DV6") = 
    printheadHotendOffset(hotendDescriptor) + [-xCarriageHotendSideSize(xCarriageType).x/2, carriage_size(xCarriageType).y/2 + 5, 0];
function grooveMountSize(blower_type, hotendDescriptor="E3DV6") = [printheadHotendOffset(hotendDescriptor).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;

module xCarriageGroovemountMGN9C(halfCarriage, inserts=false) {
    xCarriageType = MGN9C_carriage;
    size = xCarriageHotendSideSize(xCarriageType, beltWidth());
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    grooveMountSize = grooveMountSize(blower_type, hotendDescriptor);
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    rotate([0, -90, 0])
        difference() {
            union() {
                xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, halfCarriage=halfCarriage, strainRelief=false, countersunk=4, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
                E3DV6HotendHolder(xCarriageType, xCarriageHotendSideSize(xCarriageType), grooveMountSize, hotendOffset, blower_type, baffle=true, left=true);
            }
            xCarriageHotendSideHolePositions(xCarriageType)
                if (inserts) {
                    insertHoleM3(size.y, horizontal=true);
                } else {
                    boltHoleM3Tap(size.y, horizontal=true, rotate=180);
                    boltHoleM3Tap(size.y+3, horizontal=true, rotate=180, chamfer_both_ends=false);
                }
        }
}

module X_Carriage_Groovemount_MGN9C_HC_stl() {
    stl("X_Carriage_Groovemount_MGN9C_HC")
        color(pp4_colour)
            xCarriageGroovemountMGN9C(halfCarriage=true);
}

module X_Carriage_Groovemount_MGN9C_stl() {
    stl("X_Carriage_Groovemount_MGN9C")
        color(pp4_colour)
            xCarriageGroovemountMGN9C(halfCarriage=false);
}

//pose(a=[55, 0, 25 + 290])
module xCarriageGroovemountMGN9CAssembly(halfCarriage) {

    xCarriageType = MGN9C_carriage;
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);

    rotate([0, 90, 0])
        stl_colour(pp4_colour)
            if (halfCarriage)
                X_Carriage_Groovemount_MGN9C_HC_stl();
            else
                X_Carriage_Groovemount_MGN9C_stl();

    grooveMountSize = grooveMountSize(blower_type, hotendDescriptor);

    explode([-20, 0, 10], true)
        E3DV6HotendPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=true);
    explode([-20, 0, -10], true)
        E3DV6HotendHolderAlign(hotendOffset, left=true)
            blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type)
                rotate([-90, 0, 0]) {
                    stl_colour(pp2_colour)
                        E3DV6_Fan_Duct_stl();
                    Fan_Duct_hardware(blower_type);
                }
}

module E3DV6_Fan_Duct_stl() {
    stl("E3DV6_Fan_Duct")
        color(pp2_colour)
            fanDuct(BL30x10, printheadHotendOffset("E3DV6").x);
}
