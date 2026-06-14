# Brick Breaker - MASM Assembly 

A full-featured retro arcade game built entirely in x86 assembly language, featuring dynamic gameplay, power-ups, multi-level progression, and pixel-perfect graphics rendering.

![Team](https://img.shields.io/badge/Team-Ermish%2C%20Sawaira%2C%20Ahmed%2C%20Hanzala-brightgreen?style=flat-square) ![Status](https://img.shields.io/badge/Status-Complete-success?style=flat-square) ![Language](https://img.shields.io/badge/Language-MASM%20Assembly-blue?style=flat-square)

---

## Overview

This is **Final Version** of our Brick Breaker game, a complete arcade experience written in pure MASM (Microsoft Macro Assembler) x86 assembly. The game challenges players to break all bricks while managing lives, collecting bonuses, and progressing through multiple difficulty levels.

### Key Features

- **3+ Progressive Levels** – Increasing brick counts (75 → 90 → 105 bricks)
- **Dynamic Power-Up System** – 5 bonus types with timed effects
  - Slow Ball (Cyan) – Reduce ball velocity
  - Fast Ball (Red) – Increase ball velocity
  - +1 Life (Green) – Extra life
  - Wide Paddle (Yellow) – Expanded hit zone
  - Narrow Paddle (Purple) – Challenge modifier
- **Real-Time Physics** – Smooth ball movement, collision detection, paddle interaction
- **High Score Tracking** – Persistent ranking system
- **Immersive UI** – Neon-framed menus, animated menu ball, typed text effects
- **Audio Feedback** – Sound effects for paddle hits, brick breaks, bonuses, and level completion
- **Player Customization** – Name entry with live display

---

## Technical Architecture

### Core Systems

#### **Graphics Engine**
- **320×200 VGA Mode 13h** – 256-color palette rendering
- **Character-Based Font System** – 47-character bitmap font table (8×8 pixels per character)
- **Primitive Drawing Functions**
  - `DrawString()` – Text rendering with color support
  - `DrawRect()` / `FillRect()` – Rectangle operations
  - `DrawHLine()` / `DrawVLine()` – Line drawing
  - `DrawChar()` – Single character rendering
- **Neon Frame Borders** – Custom UI styling with color gradients

#### **Game Logic**
- **Paddle Control** – Keyboard input (Arrow keys/A-D) with boundary collision
- **Ball Physics** – Velocity vectors with speed modulation, wall & paddle bouncing
- **Brick Grid Management** – Bit-based state tracking (1=alive, 0=destroyed)
- **Collision Detection** – Ball-to-paddle, ball-to-brick, ball-to-boundary

#### **Power-Up System**
- **Random Spawn** – Generates every 3rd brick break
- **Gravity-Based Fall** – Bonus items descend with collision detection
- **Effect Management** – Timer-based activation with real-time gameplay integration
- **Single Active Bonus** – Prevents stacking, enforces strategic gameplay

#### **State Management**
- **Screen Transitions** – Home → Name Input → Menu → Game → Win/Lose → Menu
- **Game Variables**
  - `lives_count`, `score`, `current_level`
  - `ball_x`, `ball_y`, `ball_dx`, `ball_dy`
  - `paddle_x`, `paddle_y`, `paddle_width`
  - `bonus_active`, `bonus_type`, `bonus_timer`

### Memory Layout

```asm
.DATA
  ; Game State
  paddle_x/y, paddle_width, paddle_speed
  ball_x/y, ball_dx/dy, ball_speed, ball_launched
  
  ; Level Data
  brick_state (75 bytes), brick_state2 (90 bytes), brick_state3 (105 bytes)
  lives_count, score, current_level
  
  ; UI/Display
  font_table (376 bytes - 47 characters × 8 bytes)
  Screen buffers and string templates
  
  ; Power-Up System
  bonus_active, bonus_x/y, bonus_type, bonus_timer, bonus_effect
```

## Gameplay Mechanics
 ### Game Flow
- Home Screen – Animated brick background with team branding
- Name Input – Custom player name entry with backspace support
- Main Menu – 4 options: Start Game, Instructions, High Scores, Exit
- Animated ball bouncing between menu sections
- Instructions – 2-page guide with controls, objectives, and bonus info
- High Score Screen – Top 5 all-time scores with rankings
- Game Session – Break all bricks to advance levels
- Win/Lose Screen – Stats display with next level or restart options

### Controls
Key	Action
← / A	Move paddle left
→ / D	Move paddle right
SPACE	Launch/bounce ball
ENTER	Select menu option
UP/DOWN	Navigate menu
ESC	Return to menu / Exit
Winning Conditions
Level Complete – Destroy all bricks → advance to next level
Game Over – Lose 3 lives (ball falls off screen)
Win Game – Complete Level 3 successfully

### Level Progression
Level	Grid	Bricks	Difficulty
1	5×15	75	Beginner
2	6×15	90	Intermediate
3	7×15	105	Advanced

### Visual Design
Color Palette
- Neon Cyan (05h) – Primary UI, borders, menu highlights
- Bright Red (0Ch) – Alerts, danger states
- Bright Green (0Ah) – Success, bonus items
- Yellow (0Eh) – Warnings, secondary highlights
- Magenta (0Dh) – Selected items, titles
- White (0Fh) – Primary text
- Dark (00h) – Background

### Font System
Custom 8×8 bitmap font includes:
- A-Z, 0-9, special characters (|, -, >, :, !, /, ., _)
- Custom symbols (❤ heart, ◆ diamond, ● circle)

### Audio System
Frequency-based sound effects (Hz):
- Paddle Hit – 800 Hz
- Brick Break – 1200 Hz
- Bonus Pickup – 1000 Hz
- Level Win – 600 Hz
- Life Lost – 300 Hz
- Menu Navigation – 400 Hz

### File Structure
Code
Brick-Breaker-in-MASM-Assembly
```
├── main.asm              # Complete game implementation
├── README.md              # This file
└── Documentation/         # Technical guides (optional)
```
## Building & Running
Requirements
- MASM 6.11 or compatible x86 assembler
- DOS/Windows XP or earlier (VGA mode support required)
- DOSBox or similar emulator for modern systems

### Compilation
```bash
# Assemble
ml /c main.asm
```
### Link
```link
main.obj
```
### Execute
main.exe
Running in DOSBox
```bash
mount c: .
c:
main.exe
```

## Team
Ermish | Sawaira | Ahmed | Hanzala
