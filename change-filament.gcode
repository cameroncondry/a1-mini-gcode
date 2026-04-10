; ===== IMPORTANT! ====================================
; DOES NOT WORK! This is for testing currently.

; =====================================================
; ===== TEST HARNESS: DEBUGGING =======================
M1002 gcode_claim_action : 2            ; status: preheating
M400                                    ; wait for movements
G90                                     ; absolute positioning
M211 X1 Y1 Z1                           ; enable soft endstops

; safe axis recovery
M17                                     ; enable motors
G28 X Y                                 ; home X/Y first
G91                                     ; relative positioning
G380 S2 Z10 F1200                       ; guarded Z lift / clearance (up 10mm)
G90                                     ; absolute positioning
G0 X55 Y175 F3000                       ; safe place before any Z handling
G28 Z P0 T300                           ; safely home Z with low precision
M400

; =====================================================
; Digital "chirp-chirp-chirp" rising tone.
; =====================================================
M400 S1
M1006 S1
M1006 A0 B0 L40 C60 D10 M100 E60 F10 N100  ; C5
M1006 A0 B0 L40 C62 D10 M100 E62 F10 N100  ; D5
M1006 A0 B0 L40 C64 D10 M100 E64 F10 N100  ; E5
M1006 A0 B0 L40 C65 D10 M100 E65 F10 N100  ; F5
M1006 A0 B0 L40 C67 D10 M100 E67 F10 N100  ; G5
M1006 A0 B0 L120 C72 D10 M100 E72 F10 N100 ; C6
M1006 W

; IMPORTANT:
; At this prompt, use CANCEL on the printer/app.
; Do not hit resume unless you intentionally want to continue.
M400 U1

; optional safe state if resume is pressed by accident
M104 S0
M140 S0
M106 P1 S0
M107
M400
M18

; ===== END TEST HARNESS ==============================