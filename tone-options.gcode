; A1 Mini Start Tone Options
; These G-code snippets use the M1006 command to play melodies on the A1 Mini.
; You can copy and paste any of these blocks into your machine-start.gcode file.

; =====================================================
; OPTION 1: Digital Beep (Classic)
; A short, 3-note high-pitched digital sequence.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L50 C60 D10 M100 E60 F10 N100  ; Note 1 (Hi-C)
M1006 A0 B0 L50 C64 D10 M100 E64 F10 N100  ; Note 2 (Hi-E)
M1006 A0 B0 L50 C67 D10 M100 E67 F10 N100  ; Note 3 (Hi-G)
M1006 W
M18

; =====================================================
; OPTION 2: Rising Coin Sound
; A quick, iconic 2-note ascending sequence.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C59 D10 M100 E59 F10 N100  ; Note 1 (B5)
M1006 A0 B0 L120 C64 D10 M100 E64 F10 N100 ; Note 2 (E6)
M1006 W
M18

; =====================================================
; OPTION 3: Arpeggio Start
; A smooth, 4-note ascending major arpeggio.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L60 C48 D10 M100 E48 F10 N100  ; C4
M1006 A0 B0 L60 C52 D10 M100 E52 F10 N100  ; E4
M1006 A0 B0 L60 C55 D10 M100 E55 F10 N100  ; G4
M1006 A0 B0 L60 C60 D10 M100 E60 F10 N100  ; C5
M1006 W
M18

; =====================================================
; OPTION 4: Low-Profile "Beep-Boop"
; A simple, two-tone notification that isn't intrusive.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L80 C44 D10 M100 E44 F10 N100  ; Low tone
M1006 A0 B0 L80 C56 D10 M100 E56 F10 N100  ; High tone
M1006 W
M18

; =====================================================
; OPTION 5: Fanfare Short
; A 5-note triumphant mini-melody.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L60 C52 D10 M100 E52 F10 N100  ; E
M1006 A0 B0 L60 C52 D10 M100 E52 F10 N100  ; E
M1006 A0 B0 L60 C52 D10 M100 E52 F10 N100  ; E
M1006 A0 B0 L60 C48 D10 M100 E48 F10 N100  ; C
M1006 A0 B0 L120 C55 D10 M100 E55 F10 N100 ; G
M1006 W
M18

; =====================================================
; OPTION 6: Major Power-Up
; Iconic rising "success" sound.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C44 D5 M100 E44 F5 N100   ; G#3
M1006 A0 B0 L40 C47 D5 M100 E47 F5 N100   ; B3
M1006 A0 B0 L40 C52 D5 M100 E52 F5 N100   ; E4
M1006 A0 B0 L40 C56 D5 M100 E56 F5 N100   ; G#4
M1006 A0 B0 L40 C59 D5 M100 E59 F5 N100   ; B4
M1006 A0 B0 L40 C64 D5 M100 E64 F5 N100   ; E5
M1006 W
M18

; =====================================================
; OPTION 7: Electronic Healing
; A smooth 4-note "recharge" melody.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L100 C67 D10 M100 E67 F10 N100 ; G5
M1006 A0 B0 L100 C64 D10 M100 E64 F10 N100 ; E5
M1006 A0 B0 L100 C67 D10 M100 E67 F10 N100 ; G5
M1006 A0 B0 L150 C72 D10 M100 E72 F10 N100 ; C6
M1006 W
M18

; =====================================
; OPTION 8: Digital Evolution
; Digital "chirp-chirp-chirp" rising tone.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C60 D10 M100 E60 F10 N100  ; C5
M1006 A0 B0 L40 C62 D10 M100 E62 F10 N100  ; D5
M1006 A0 B0 L40 C64 D10 M100 E64 F10 N100  ; E5
M1006 A0 B0 L40 C65 D10 M100 E65 F10 N100  ; F5
M1006 A0 B0 L40 C67 D10 M100 E67 F10 N100  ; G5
M1006 A0 B0 L120 C72 D10 M100 E72 F10 N100 ; C6
M1006 W
M18

; =====================================================
; OPTION 8.1: Evolution Var - Quick Chirp
; Half duration per note for a snappier digital sound.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L20 C60 D10 M100 E60 F10 N100
M1006 A0 B0 L20 C62 D10 M100 E62 F10 N100
M1006 A0 B0 L20 C64 D10 M100 E64 F10 N100
M1006 A0 B0 L20 C65 D10 M100 E65 F10 N100
M1006 A0 B0 L20 C67 D10 M100 E67 F10 N100
M1006 A0 B0 L60 C72 D10 M100 E72 F10 N100
M1006 W
M18

; =====================================================
; OPTION 8.2: Evolution Var - High Frequency
; Shifted up one octave for a more piercing digital feel.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C72 D10 M100 E72 F10 N100  ; C6
M1006 A0 B0 L40 C74 D10 M100 E74 F10 N100  ; D6
M1006 A0 B0 L40 C76 D10 M100 E76 F10 N100  ; E6
M1006 A0 B0 L40 C77 D10 M100 E77 F10 N100  ; F6
M1006 A0 B0 L40 C79 D10 M100 E79 F10 N100  ; G6
M1006 A0 B0 L120 C84 D10 M100 E84 F10 N100 ; C7
M1006 W
M18

; =====================================================
; OPTION 8.3: Evolution Var - Staccato Double
; Short rests between notes to emphasize the "chirp".
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L30 C60 D10 M100 E60 F10 N100
M1006 A0 B10 L20 C0 D10 M100 E0 F10 N100  ; Rest
M1006 A0 B0 L30 C64 D10 M100 E64 F10 N100
M1006 A0 B10 L20 C0 D10 M100 E0 F10 N100  ; Rest
M1006 A0 B0 L30 C67 D10 M100 E67 F10 N100
M1006 A0 B10 L20 C0 D10 M100 E0 F10 N100  ; Rest
M1006 A0 B0 L120 C72 D10 M100 E72 F10 N100
M1006 W
M18

; =====================================================
; OPTION 8.4: Evolution Var - Chromatic Glide
; Uses semi-tones for a smoother, glissando-like climb.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L30 C60 D10 M100 E60 F10 N100  ; C5
M1006 A0 B0 L30 C61 D10 M100 E61 F10 N100  ; C#5
M1006 A0 B0 L30 C62 D10 M100 E62 F10 N100  ; D5
M1006 A0 B0 L30 C63 D10 M100 E63 F10 N100  ; D#5
M1006 A0 B0 L30 C64 D10 M100 E64 F10 N100  ; E5
M1006 A0 B0 L30 C65 D10 M100 E65 F10 N100  ; F5
M1006 A0 B0 L30 C66 D10 M100 E66 F10 N100  ; F#5
M1006 A0 B0 L30 C67 D10 M100 E67 F10 N100  ; G5
M1006 A0 B0 L120 C72 D10 M100 E72 F10 N100 ; C6
M1006 W
M18

; =====================================================
; OPTION 8.5: Evolution Var - Flourish End
; Standard climb but with a final vibrato/trill finish.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C60 D10 M100 E60 F10 N100
M1006 A0 B0 L40 C64 D10 M100 E64 F10 N100
M1006 A0 B0 L40 C67 D10 M100 E67 F10 N100
M1006 A0 B0 L30 C72 D10 M100 E72 F10 N100 ; C6
M1006 A0 B0 L30 C71 D10 M100 E71 F10 N100 ; B5
M1006 A0 B0 L30 C72 D10 M100 E72 F10 N100 ; C6
M1006 A0 B0 L120 C72 D10 M100 E72 F10 N100 ; C6 (hold)
M1006 W
M18

; =====================================================
; OPTION 9: High Level Rise
; A fast, high-pitched ascending flourish.
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L50 C67 D5 M100 E67 F5 N100   ; G5
M1006 A0 B0 L50 C69 D5 M100 E69 F5 N100   ; A5
M1006 A0 B0 L50 C71 D5 M100 E71 F5 N100   ; B5
M1006 A0 B0 L150 C72 D10 M100 E72 F10 N100 ; C6
M1006 W
M18

; =====================================================
; OPTION 10: Digital Gulp
; A quick, rubbery digital "blip".
; =====================================================
M17
M400 S1
M1006 S1
M1006 A0 B0 L40 C52 D10 M100 E52 F10 N100  ; E4
M1006 A0 B0 L40 C55 D10 M100 E55 F10 N100  ; G4
M1006 A0 B0 L120 C64 D10 M100 E64 F10 N100 ; E5
M1006 W
M18
