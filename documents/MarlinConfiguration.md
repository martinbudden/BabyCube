# Marlin Configuration

D - Disable, ie place `//` at the start of a line<br>
E - Enable, ie delete the `//` at the start of a line<br>
C - Change<br>
E&C - Enable and Change

## Configuration.h

```h
C
#define SERIAL_PORT 2
E
#define SERIAL_PORT_2 -1
E&C
#define CUSTOM_MACHINE_NAME "BabyCube"
E
#define PIDTEMPBED
E
#define COREXY
D
//#define USE_ZMIN_PLUG
E
#define USE_ZMAX_PLUG
C
#define X_DRIVER_TYPE  TMC2209
#define Y_DRIVER_TYPE  TMC2209
#define Z_DRIVER_TYPE  TMC2209
#define E0_DRIVER_TYPE TMC2209
C
#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 400, 136 }
D
//#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN
E
#define PROBE_MANUALLY
C
#define INVERT_Y_DIR false
#define INVERT_Z_DIR true
#define INVERT_E0_DIR true
C
#define Z_HOME_DIR 1
C
#define X_BED_SIZE 100
#define Y_BED_SIZE 75

C
#define X_MIN_POS -12
#define Y_MIN_POS 0
#define Z_MAX_POS 60
E
#define AUTO_BED_LEVELING_3POINT
E
#define RESTORE_LEVELING_AFTER_G28
C
#define HOMING_FEEDRATE_MM_M { (20*60), (20*60), (2*60) }
E
#define EEPROM_SETTINGS
E
#define SDSUPPORT
E
#define SD_CHECK_AND_RETRY
E
#define INDIVIDUAL_AXIS_HOMING_MENU
E
#define SPEAKER
E
#define CR10_STOCKDISPLAY
```

## Configuration_adv.h

```h
C
#define PID_EXTRUSION_SCALING
C
#define THERMAL_PROTECTION_PERIOD 60        // Seconds
C
#define THERMAL_PROTECTION_HYSTERESIS 10     // Degrees Celsius
C
#define WATCH_TEMP_PERIOD  30               // Seconds
C
#define THERMAL_PROTECTION_BED_PERIOD        60 // Seconds
C
#define THERMAL_PROTECTION_BED_HYSTERESIS     10 // Degrees Celsius
C
#define FAN_MAX_PWM 157  // To run 12V fan at 19.5V, 12/19.5*255=157
C
#define E0_AUTO_FAN_PIN FAN1_PIN
C
#define EXTRUDER_AUTO_FAN_SPEED 150  // To run 12V fan at 19.5V, 12/19.5*255=157, set to 150, just below max speed to reduce noise
E
#define SENSORLESS_BACKOFF_MM  { 2, 2, 0 }       // (mm) Backoff from endstops before sensorless homing
C
#define HOMING_BUMP_MM      { 0, 0, 0 }       // (mm) Backoff from endstops after first bump
C
#define HOMING_BACKOFF_POST_MM { 2, 2, 2 }    // (mm) Backoff from endstops after homing
E
#define HOME_Y_BEFORE_X                       // If G28 contains XY home Y before X
E
#define STATUS_MESSAGE_SCROLLING
E
#define LCD_SET_PROGRESS_MANUALLY
C
#define EVENT_GCODE_SD_ABORT "G28XY\nM84" // G-code to run on SD Abort Print (e.g., "G28XY" or "G27")
E
#define LONG_FILENAME_HOST_SUPPORT
E
#define SCROLL_LONG_FILENAMES
E
#define BABYSTEPPING
E
#define BABYSTEP_WITHOUT_HOMING
E
#define BABYSTEP_ZPROBE_OFFSET            // Combine M851 Z and Babystepping
E
#define LIN_ADVANCE
C
#define LIN_ADVANCE_K 0.0     // Unit: mm compression per 1mm/s extruder speed
C
#define X_CURRENT       600        // (mA) RMS current. Multiply by 1.414 for peak current.
C
#define Y_CURRENT       600
D
//#define STEALTHCHOP_Z
D
//#define STEALTHCHOP_E
C
#define CHOPPER_TIMING CHOPPER_DEFAULT_19V        // All axes (override below)
E
#define HYBRID_THRESHOLD
E
#define SENSORLESS_HOMING // StallGuard capable drivers only
C
#define X_STALL_SENSITIVITY  45
C
#define Y_STALL_SENSITIVITY  15
C
#define Z_STALL_SENSITIVITY  100
E
#define IMPROVE_HOMING_RELIABILITY
E
#define HOST_ACTION_COMMANDS
```
