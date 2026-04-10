; A1 Mini Optimized Start Routine:
; Provides a drop-in replacement for an optimized start
; routine that aims to be faster, safer, and quieter.

; =====================================================
; ===== Machine: A1 Mini ==============================
; ===== Version: 1.4.0 ================================
; ===== Date: April 10, 2026 ==========================
; ===== Company: Cascade Media LLC ====================
; ===== Modified By: Cameron Condry ===================
; ===== Email: cameron@cascademedia.us ================
; =====================================================

; ===== start warm-up sequence ========================
M1002 gcode_claim_action : 2            ; status: heatbed preheating
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

; non-blocking preheat for nozzle probing and bed leveling with slight heat soak
M104 S140
M140 S{bed_temperature_initial_layer_single + 5}

G392 S0                                 ; disable clog detect
M9833.2                                 ; bambu: set noise params

; ===== start printer sound ===========================
M17                                     ; enable motors for sound
M400 S1                                 ; wait for sync
M1006 S1                                ; enable sound speaker
M1006 A0 B0 L40 C60 D10 M100 E60 F10 N100   ; C5
M1006 A0 B0 L40 C62 D10 M100 E62 F10 N100   ; D5
M1006 A0 B0 L40 C64 D10 M100 E64 F10 N100   ; E5
M1006 A0 B0 L40 C65 D10 M100 E65 F10 N100   ; F5
M1006 A0 B0 L40 C67 D10 M100 E67 F10 N100   ; G5
M1006 A0 B0 L80 C72 D10 M100 E72 F10 N100   ; C6
M1006 W                                 ; wait for sound to finish
M18                                     ; disable motors to reset

; ===== initialize printer state ======================
G90                                     ; absolute positioning
M83                                     ; relative extrusion
M211 X1 Y1 Z1                           ; enable soft endstops
M630 S0 P0                              ; bambu: reset internal state

M204 S6000                              ; set default acceleration
M17 X0.7 Y0.9 Z0.3                      ; set optimized motor currents
M960 S5 P1                              ; enable toolhead lamp
M220 S100                               ; reset feedrate to 100%
M221 S100                               ; reset flowrate to 100%

M982.2 S1                               ; enable cog noise reduction
M975 S1                                 ; enable vibration suppression
M106 P1 S0                              ; disable fan while heating
M73.2 R1.0                              ; reset time left

; ===== safe axis recovery (first move) ===============
M1002 gcode_claim_action : 13           ; status: toolhead homing
M17                                     ; enable motors (baseline)
G91                                     ; relative positioning
G380 S2 Z10 F1200                       ; guarded Z up
G380 S3 Z-6 F1200                       ; guarded Z down
G1 Z4 F1200                             ; add clearance
G90                                     ; absolute positioning
M400                                    ; wait for moves to finish

; ===== home and stage toolhead =======================
G28 X Y                                 ; home X and Y first
G1 X50 Y175 F6000                       ; move to safe and stable spot for Z-homing
G28 Z P0 T300                           ; home Z with low precision
M17 Z0.5                                ; restore Z current to default after homing
M400

; ===== disable endstops ==============================
M211 S                                  ; push soft endstops status
M211 X0 Y0 Z0                           ; disable soft endstops for wiper access

;===== build plate detection (flagged) ================
M1002 judge_flag build_plate_detect_flag
M622 S1
    G39.4                               ; bambu: quick build plate detection
    M400
M623

; perform first wipe for easily removable filament
G1 Z5 F3000                             ; clearance
G1 X0 F12000                            ; move to service area edge
G1 X-13.5 F3000                         ; move nozzle into wiper
G1 X0 F24000                            ; reset to edge
G1 X-13.5 F3000                         ; double wipe, end in wiper for final flick
M400

;===== switch material in AMS =========================
M620 M                                  ; enable remap
M620 S[initial_no_support_extruder]A
    G392 S1                             ; enable clog detect
    M1002 gcode_claim_action : 4        ; status: load filament
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S[nozzle_temperature_initial_layer]
    M104 S250                           ; common flush temp
    M400
    T[initial_no_support_extruder]
    G1 X-13.5 F3000
    M400
    M620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}
    M109 S250
    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}
    M104 S{flush_temperatures[initial_no_support_extruder]}
    G92 E0
    G1 E50 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}
    M400
    M106 P1 S178
    G92 E0
    G1 E5 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}
    ; drop nozzle temp to make filament shink a bit
    M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}
    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-40}
    G92 E0
    G1 E-0.5 F300

    G1 X0 F12000
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000

    M104 S140                           ; reset nozzle to expected temperature
    G392 S0                             ; disable clog detect
M621 S[initial_no_support_extruder]A

; ===== clean nozzle ==================================
; NOTE: vibration compensation skipped in favor of periodic manual calibration
; NOTE: previous material is unknown, needs enough heat for "most" materials
M1002 gcode_claim_action : 7            ; status: heat the nozzle
M109 S170                               ; set to conservative temperature

M1002 gcode_claim_action : 14           ; status: toolhead cleaning
M106 P1 S255                            ; short fan blast to neck any strands
G4 P3000                                ; pause for fan
M106 P1 S0                              ; keep fan off during cleaning

G90                                     ; absolute positioning
M83                                     ; relative extrusion

; perform a short knock sequence by bending oozed filament
G1 Z5 F3000                             ; clearance
G1 E-1.0 F1200                          ; small retract before taps
G1 X90 Y-4 F12000                       ; move to the purge area
G380 S3 Z-1 F1200                       ; gentle tap on plate x1
G1 Z2 F3000                             ; clearance
G1 X91 F6000                            ; reposition to the right
G380 S3 Z-1 F1200                       ; x2
G1 Z2 F3000
G1 X92 F6000
G380 S3 Z-1 F1200                       ; x3
G1 Z2 F3000
G1 X93 F6000
G380 S3 Z-1 F1200                       ; x4
G1 Z2 F3000
G1 X94 F6000
G380 S3 Z-1 F1200                       ; x5
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; x6
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; x7

; brush oozed filament on rubber
G1 Z5 F3000                             ; clearance
G1 X25 Y185 F12000                      ; move to position
G1 Z0.2 F1200                           ; lower to brush
G91
G1 X-35 F24000                          ; circular pattern
G1 Y-2
G1 X32
G1 Y1.5
G1 X-33
G1 Y-2
G1 X35
G1 Y1.5
G1 X-35
G90

; brush oozed filament on rubber, offset
G1 Z5 F3000                             ; clearance
G1 X25 Y186 F12000                      ; move to position
G1 Z0.3 F1200                           ; lower to brush
G91
G1 X-35 F24000                          ; circular pattern
G1 Y-2
G1 X32
G1 Y1.5
G1 X-33
G1 Y-2
G1 X35
G1 Y1.5
G1 X-35
G90

; wipe any remaining filament
G1 Z5 F3000                             ; clearance
G1 X0 F12000                            ; move to service area edge
G1 X-13.5 F3000                         ; move nozzle into the wiper
M106 P1 S255                            ; short fan blast
G4 P3000                                ; pause for fan
G1 X0 F24000                            ; reset to edge
G1 X-13.5 F3000                         ; double wipe
M106 P1 S0                              ; keep fan off during leveling
M400

; ===== restore protections ===========================
M211 R                                  ; restore soft endstops status
G29.2 S0                                ; disable ABL for raw Z

;===== park and wait for heating ======================
; set nozzle for probing and wait for bed to final temperature
M1002 gcode_claim_action : 2            ; status: heatbed preheating
M104 S140                               ; nozzle probing temperature
M190 S[bed_temperature_initial_layer_single]
M109 S140                               ; wait for nozzle
M400                                    ; stabilize temperature

;===== bed leveling (flagged) =========================
M1002 judge_flag g29_before_print_flag
M622 J1
    M1002 gcode_claim_action : 1        ; status: bed leveling
    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500                                ; save mesh
M623

M1002 judge_flag g29_before_print_flag
M622 J0
    M1002 gcode_claim_action : 13       ; status: toolhead homing
    G28 T300                            ; permissive temp home
M623

G29.2 S1                                ; enable ABL with mesh

;===== nozzle load line ===============================
M1002 gcode_claim_action : 7            ; status: heat the nozzle
M975 S1                                 ; enable motion gating (explicit)
G90                                     ; re-assert positioning (explicit)
M83                                     ; re-assert extrusion (explicit)
T1000                                   ; select local tool

M211 S                                  ; push soft endstops status
M211 X0 Y0 Z0                           ; disable soft endstop
G1 Z5 F3000                             ; clearance
G1 X0 Y0 F12000                         ; move to service area
G1 X-13.5 F3000                         ; move into wiper

; set and wait for nozzle to final temperature
M109 S{nozzle_temperature_initial_layer[initial_extruder]}

;===== prepare sensors for calibration ================
M1002 set_filament_type:UNKNOWN         ; reset filament for calibration
M412 S1                                 ; enable runout detect
M620.3 W1                               ; enable tangle detect
G392 S0                                 ; disable clog detect during calibration
M400 S2                                 ; settle sensors
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

; minimal prime with micro-retract inside service area
G92 E0                                  ; reset extruded amount before line
G1 E1.2 F500                            ; extrude into melt zone
G1 E-0.35 F1200                         ; micro-retract before purging

;===== dynamic flow calibration (flagged) =============
M1002 judge_flag extrude_cali_flag
M622 J1
    M1002 gcode_claim_action : 8        ; status: dynamic flow calibration

    M900 K0.0 L1000.0 M1.0              ; pressure advance baseline
    G90
    M83

    G1 Z5 F3000
    G1 X68 Y-4.2 F24000                 ; move near start position
    G1 Z0.3 F3000                       ; move to start position
    G1 X88 E10 F{outer_wall_volumetric_speed/(24/20)*60}
    G1 X93 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G1 X98 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
    G1 X103 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G1 X108 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
    G1 X113 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G1 Y0 F24000
    G1 Z0 F3000                         ; finish the patterned sweep
    M400

    G1 Z10 F3000
    G1 X-13.5 Y0 F12000                 ; park in service area
    M400

    ; primary dynamic extrusion compensation
    G1 E10 F{outer_wall_volumetric_speed/2.4*60}
    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]
    M106 P1 S255                        ; enable fan to neck strand
    M400 S7                             ; short settle

    G1 X0 F12000                        ; wipe & shake
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000
    M400
    M106 P1 S0                          ; disable fan

    ; retry once if needed
    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]
        M106 P1 S255
        M400 S7
        G1 X0 F24000
        G1 X-13.5 F3000
        G1 X0 F24000
        G1 X-13.5 F3000
        M400
        M106 P1 S0
    M623

    ; final corrections and cleanup
    G1 X-13.5 F3000
    M400
    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]
    M106 P1 S180
    M400 S7
    G1 X0 F24000
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000
    M400
    M106 P1 S0
M623                                    ; end flow dynamics calibration

;===== extrude calibration test =======================
; hold first-layer temps and set modes (explicit)
M140 S{bed_temperature_initial_layer_single}
M109 S{nozzle_temperature_initial_layer[initial_extruder]}
M190 S{bed_temperature_initial_layer_single}

G90                                     ; re-assert positioning (explicit)
M83                                     ; re-assert extrusion (explicit)

; clear any ooze before calibrating
M106 P1 S255                            ; full fan to neck ooze before calibration
G4 P2000                                ; wait 1 seconds
G1 E-0.05 F1200                         ; create a tiny gap before wiping
G1 X0 F12000
G1 X-13.5 F3000
G1 X0 F24000
G1 X-13.5 F3000
M400
M106 P1 S0

; draw stabilization pattern
G1 Z5 F3000
G1 X68 Y-2.4 F24000
G1 Z0.3 F3000
G1 X88 E10 F{outer_wall_volumetric_speed/(24/20)*60}
G1 X93 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X98 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 X103 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X108 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 X113 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X115 Z0 F24000
G1 Z5 F3000                             ; final clearance
M400

;===== normalize lights/fans ==========================
; @NOTE: includes defensive Bambu compatibility cleanup for future variants
M960 S1 P0                              ; light/laser ch1 off
M960 S2 P0                              ; light/laser ch2 off
M960 S5 P0                              ; toolhead lamp off
M106 P1 S0                              ; part fan off
M106 P2 S0                              ; aux fan off
M106 P3 S0                              ; chamber fan off

;===== final staging ==================================
M1002 gcode_claim_action : 0            ; status: clear
G392 S1                                 ; re-enable clog detect
M975 S1                                 ; keep vibration suppression on
G90                                     ; absolute positioning
M83                                     ; relative extrusion
M211 R                                  ; restore soft endstops
T1000                                   ; bambu; select local tool
M1007 S1                                ; bambu: keep enabled

;===== for textured pei plate =========================
{if curr_bed_type=="Textured PEI Plate"}
    G29.1 Z{-0.02}
{endif}

; ===== hand-off to slicer first move =================
