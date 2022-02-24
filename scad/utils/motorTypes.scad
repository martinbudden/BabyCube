function isNEMAType(motorType) = is_list(motorType) && motorType[0][0] == "N";

function motorType(motorString) = motorString == 14 ? NEMA14T() : NEMA17_40;
function motorType(motorDescriptor) =
    motorDescriptor == "NEMA14" ? NEMA14_36 :
    motorDescriptor == "NEMA14_36" ? NEMA14_36 :
    motorDescriptor == "NEMA14_L150" ? NEMA14_L150 :
    motorDescriptor == "NEMA17_20" ? NEMA17_20 :
    motorDescriptor == "NEMA17_27" ? NEMA17_27 :
    motorDescriptor == "NEMA17_34" ? NEMA17_34 :
    motorDescriptor == "NEMA17" ? NEMA17_40 :
    motorDescriptor == "NEMA17_40" ? NEMA17_40 :
    motorDescriptor == "NEMA17_34L150" ? NEMA17_34L150 :
    motorDescriptor == "NEMA17_40L150" ? NEMA17_40L150 :
    undef;

function motorWidth(motorString) = motorString == "NEMA14" || motorString == "NEMA14_36" || motorString == "NEMA14_L150" ? 35.2 : 42.3;
