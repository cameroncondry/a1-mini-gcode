; A1 Mini Optimized Start Routine:
; Provides a drop-in replacement for an optimized start
; routine that aims to be faster, safer, and quieter.

; =====================================================
; ===== Machine: A1 Mini ==============================
; ===== Version: 1.4.0 ================================
; ===== Date: April 04, 2026 ==========================
; ===== Company: Cascade Media LLC ====================
; ===== Modified By: Cameron Condry ===================
; =====================================================

; ===== start warm-up sequence ========================
M1002 gcode_claim_action : 2            ; status: heatbed preheating
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

; non-blocking preheat for nozzle probing and bed leveling
M104 S140
M140 S{bed_temperature_initial_layer_single}

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
; @TODO: review all status messages and update where possible
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
G0 X50 Y175 F3000                       ; move to safe and stable spot for Z-homing
G28 Z P0 T300                           ; home Z with low precision
M17 Z0.5                                ; restore Z current to default after homing
M400                                    ; wait for moves to finish

; ===== disable endstops ==============================
M211 S                                  ; push soft endstop status
M211 X0 Y0 Z0                           ; disable soft endstops for wiper access

;===== build plate detection (flagged) ================
M1002 judge_flag build_plate_detect_flag
M622 S1
    G39.4                               ; bambu: quick build plate detection
    M400
M623

; @TODO: review F accelleration values and increase after testing
; perform first wipe for easily removable filament
G1 Z5 F3000                             ; clearance
G1 X0 F3000                             ; move to service area edge
G1 X-13.5 F3000                         ; move nozzle into the wiper
G1 X0 F10000                            ; reset to edge
G1 X-13.5 F3000                         ; double wipe
M400                                    ; wait for moves to finish

; @TODO: add switch material in AMS section

; ===== clean nozzle ==================================
M1002 gcode_claim_action : 7            ; status: heat the nozzle
M109 S170                               ; set to conservative temperature for most materials

M1002 gcode_claim_action : 14           ; status: toolhead cleaning
M106 P1 S255                            ; short fan blast to neck any strands
G4 P1500                                ; pause for fan
M106 P1 S0                              ; keep fan off during cleaning

G90                                     ; absolute positioning
M83                                     ; relative extrusion

; perform a short knock sequence by bending oozed filament
G1 Z5 F3000                             ; clearance
G1 E-1.0 F500                           ; small retract before taps
G0 X90 Y-4 F10000                       ; move to the purge area
G380 S3 Z-1 F1200                       ; gentle tap on plate x1
G1 Z2 F3000                             ; clearance
G1 X91                                  ; reposition to the right
G380 S3 Z-1 F1200                       ; x2
G1 Z2 F3000
G1 X92
G380 S3 Z-1 F1200                       ; x3
G1 Z2 F3000
G1 X93
G380 S3 Z-1 F1200                       ; x4
G1 Z2 F3000
G1 X94
G380 S3 Z-1 F1200                       ; x5
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; x6
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; x7

; brush oozed filament on rubber
G1 Z5 F3000                             ; clearance
G1 X25 Y185 F10000                      ; move to position
G1 Z0.2 F1200                           ; lower to brush
G91
G1 X-35 F30000                          ; circular pattern
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
G1 X25 Y186 F10000                      ; move to position
G1 Z0.2 F1200                           ; lower to brush
G91
G1 X-35 F30000                          ; circular pattern
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
G1 X0                                   ; move to service area edge
M106 P1 S255                            ; short fan blast
G4 P500                                 ; pause for fan
M106 P1 S0                              ; keep fan off during leveling
G1 X-13.5                               ; move nozzle into the wiper
G1 X0 F10000                            ; reset to edge
G1 X-13.5                               ; double wipe
M400                                    ; wait for moves to finish

; ===== restore protections ===========================
M211 R                                  ; restore softend status
G1 Z5 F3000                             ; clearance
G29.2 S0                                ; disable ABL for raw Z
G0 X50 Y175 F10000
G28 Z P0 T300                           ; establish raw Z reference

;===== park and wait for heating ======================
M1002 gcode_claim_action : 2            ; status: heatbed preheating
G1 Z5 F3000                             ; clearance
G1 X90 Y90 F10000                       ; park at center

; set nozzle and wait for bed to final temperature
M104 S140                               ; nozzle probing temperature
M190 S[bed_temperature_initial_layer_single]

;===== bed leveling (flagged) =========================
M1002 judge_flag g29_before_print_flag
M622 J1
    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500                                ; save mesh
M623

M1002 gcode_claim_action : 13           ; status: toolhead homing
G28 T300                                ; permissive temp home
G29.2 S1                                ; enable ABL with mesh

;===== nozzle load line ===============================
M1002 gcode_claim_action : 0            ; status: clear
M975 S1                                 ; enable motion gating (explicit)
G90                                     ; re-assert positioning (explicit)
M83                                     ; re-assert extrusion (explicit)
T1000                                   ; select local tool

M211 S                                  ; push endstop status
M211 X0 Y0 Z0                           ; disable soft endstop
G1 Z5 F3000                             ; clearance
G1 X0 Y0 F10000                         ; move to service area
G1 X-13.5                               ; move into wiper












; IMPORTANT: Prompt the user to CANCEL the print
G4 P5000
M400 U1










