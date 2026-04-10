# Changelog: A1 Mini Optimized Start Routine

All notable changes to this project will be documented in this file.

## [1.4.0] - 2026-04-10
- Reworked startup flow for a quieter, faster, and more deliberate routine.
- Improved early homing and guarded recovery for safer startup motion.
- Better staged heating, cleaning, leveling, and calibration handoff.
- Improved nozzle cleaning with a stronger knock sequence, dual-offset brushing, and final wipe passes.
- Uses a 170C cleaning phase with hotter-material temperature clamping.
- Improved startup comments and displayed status messages.
- Refined motion behavior to reduce wasted movement and unnecessary jostling.
- Labeled startup sound blocks for easier swapping or removal.

## [1.3.4] - 2025-11-11
- Disabled vibration compensation due to eddy sensor warnings.
- Added hardcoded 140°C conservative preheat (uncommitted local change).

## [1.3.3]
- Enabled quick vibration compensation.

## [1.3.2]
- Disabled vibration compensation.
- Shows signs of under extrusion when enabled.

## [1.3.1]
- Adds a quick version of vibration compensation.

## [1.3]
- Adds 0.2mm and 0.6mm nozzle support.
- Enhances nozzle temperature handling.
- Updates guarded movements for safety.
- Adds mech-mode (vibration) optional check.
- Improved accuracy on stabilization pattern.

## [1.2]
- Optimized all paths.

## [1.1]
- Release for public.

## [1.0]
- Initial version.
