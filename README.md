# A1 Mini Optimized Start Routine

# WARNING: This is a work in progress.

An optimized startup G-code for the Bambu Lab A1 Mini, designed to be **faster, safer, and quieter** than the default routine. This project is based on my personal research and the testing shared in the Bambu Lab community forums.

## Key Features & Rationales

### 1. Optimized Heating & Non-Blocking Sequence
- **Simultaneous Prep:** Unlike the default G-code which pauses and waits for the bed to heat, this routine performs homing, wiping, and bed leveling *during* the heating process. 
- **Intelligent Preheating:** (TODO: Temp increased for better nozzle wiping) The nozzle stays at a conservative temperature (140°C or 50°C below target) during prep to prevent oozing while ensuring it is ready to reach print temperature the moment prep is finished.

### 2. Significant Noise Reduction
- **Vibration Check Logic:** Disabled the "XY mech resonance check" (the aggressive shaking) that usually runs on every print. This minimizes machine wear and house-wide noise, especially for late-night printing. It is recommended to run a manual resonance check once a week or if print artifacts appear.
- **Silent Startup:** The signature startup "music" (M1006) is removed for a truly silent power-on.
- **Fan Noise Control:** Reduced the sudden 100% fan bursts during pre-print checks to 50% to minimize acoustic spikes without compromising functional verification.

### 3. Streamlined Print Start
- **Accelerated Transitions:** Improved the move between the purge line (nozzle flush) and the actual print. By ensuring the nozzle only leaves the bed after internal processing jobs are finished, initial stringing is significantly reduced or eliminated.
- **Faster Cleaning Paths:** Optimized nozzle wiping and brushing paths to reduce overall start time by up to 60 seconds.

### 4. Safety & Maintenance
- **Guarded Movements:** Includes guarded Z-homing movements and proactive endstop management to prevent accidental collisions.
- **Eddy Sensor Stability:** (v1.3.4+) Vibration compensation is selectively disabled to avoid "eddy sensor warnings" and potential underextrusion artifacts.

## Installation
1. Open **Bambu Studio** or **OrcaSlicer**.
2. Go to the **Printer Settings** for your A1 Mini.
3. Select **Machine G-code**.
4. Replace the entire **Machine start G-code** block with the content of `machine-start-1.3.4.gcode` from this repository.

## Changelog Summary (v1.3.4)
- Disabled vibration compensation to avoid eddy sensor warnings.
- Added hardcoded 140°C conservative preheat for maximum ooze protection.
- Refined cleaning paths based on community feedback.

---
**Modified by:** Cascade Media LLC
**Based on research by:** Myzaree, kylejustknows, and the Bambu Lab Community.
**Last Updated:** April 03, 2026
