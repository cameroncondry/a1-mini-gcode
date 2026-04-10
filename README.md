# A1 Mini Optimized Start Routine

A quieter, faster, and cleaner A1 Mini start routine built for repeatable daily use.

#### Important

This modifies your machine start G-Code. Keep a copy of the default, review the script before use, and test carefully.

This routine has only been tested on my A1 Mini.

I am unable to test with:
- AMS
- standard A1
- P2S or other enclosed Bambu printers

I want to expand testing to those setups later, but for now this should be treated as A1 Mini-tested only.

## Core Features

- quieter startup with less wasted motion
- earlier, more controlled XY and Z staging
- improved nozzle cleaning for stubborn residue
- 170C cleaning phase for more reliable wipe behavior
- clearer startup messages and comments
- separate tone blocks for nozzle-specific variants
- easier to read and modify than stock

## What This Changes

Compared to stock, this routine focuses on a few main improvements:

- motion is staged more deliberately so startup feels cleaner and easier to follow
- noisy vibration compensation disabled in favor of more consistent periodic manual calibration
- cleaning stubborn filament is more consistent before leveling and printing
- comments and status messages are easier to understand

## Messages, Comments, and Maintainability

A large part of this project is making the script easier to understand.

Comments and displayed messages were cleaned up so it is easier to:
- audit changes over time
- test safely and avoid printer damage
- compare different behaviors
- provide details where they are missing

## Startup Flow

This version stages recovery, homing, and startup motion more deliberately than stock.

Highlights:
- guarded early Z recovery and controlled XY homing
- arranged to be more logical and easier to maintain
- optional build plate detection support retained with aligned nozzle positioning
- all settings tested and optimized for consistent printing behavior

## Cleaning Routine

The cleaning routine is modified to be more consistent and reliable across printers and filaments. The metal plate that the A1 Mini uses to scrub is nice, but doesn't exist on other printers. My thought here was to use the rubber brush in a more consistent and reliable way to remove stubborn residue. After a year of testing, I've found this is hard to get right.

Highlights:
- early wipe before later startup phases
- moved all cleaning moves off the build plate where possible
- higher cleaning temperature to account for different filaments
- cleaner knock sequence to help bend and break stubborn strands
- double rubber brushing with an offset and a final wipe

The goal is a routine that behaves better across edge cases and leaves less residue going into leveling, calibration, and first layer moves. The cleaner the nozzle, the better the calibration results.

## Tone Options

I generated some startup tones that can be used as a nozzle size indicator. The idea is to use a different tone for each nozzle size and have an audible indicator when the print starts.

Instructions:
- find a tone to test in `tone-options.gcode`
- look for the "start printer sound" block near the beginning of `machine-start.gcode`
- replace from `M17` to `M18` with the tone you want to use
- save and test carefully

## Installation

1. Open Bambu Studio
2. Open your A1 Mini printer profile
3. Find the machine start G-Code section
4. Replace it with `machine-start.gcode`
5. Save the profile under a new name, like `A1 Mini 04 Nozzle`
6. Run a careful first test print and stay near the printer during startup!

## Included Files

- `machine-start.gcode` - current start routine
- `machine-start-default.gcode` - stock reference
- `machine-start-1.3.4.gcode` - earlier public version

## Change-Filament and Manual Multi-Material

I'm also working on a change-filament G-Code workflow for an MMS-style manual filament changing system without an AMS.

The goal is to make manual color swaps work with any number of filaments by stopping at the change, cutting filament, prompting for the next color, then completing the load routine on its own. I am still in the testing phase to make sure the routine works well every time. However, when the printer prompts for a new filament, I only need to pull the old filament and push in the new one, and the printer takes care of the rest.