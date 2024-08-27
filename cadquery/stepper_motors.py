NEMA17_40     = ["NEMA17_40",     42.3, 40,     53.6/2, 25,     11,     2,     5,     20,          31,    [12.5, 11], 3,     False, False, 0,       0]
NEMA14_36     = ["NEMA14_36",     35.2, 36,     46.4/2, 21,     11,     2,     5,     21,          26,    [8,     8], 3,     False, False, 0,       0]

def NEMA_boss_radius(type):  return type[5] #! Boss around the spindle radius
def NEMA_hole_pitch(type):   return type[9] #! Screw hole pitch
