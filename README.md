# Ffbot-IDLE-Mods
Mods for Elbody's [FFBot Idle Game](https://elbody.itch.io/ffbot)

**Disclaimer:** Use of these mods may or may not ban you from game leaderboards!

## Project Overview
This mod enhances the FFBot experience by providing real-time data exports and audio-visual feedback. It was made possible using the [Godot PCK Explorer](https://dmitriysalnikov.itch.io/godot-pck-explorer).

Currently supports version **9.01** (latest at time of writing). I will attempt to keep this updated alongside game updates, but no promises can be made.

## Features

### 1. Audio Alerts
* **Game Over SFX**: Plays a sound when hitting a game over. 
* **Requirement**: Include a `gameover.wav` in the same folder as the game executable. You can find an example file in the project releases.

### 2. Data Export (JSON)
The mod generates two JSON files in the same location as the executable:
* **player_stats.json**: Persistent character data, core attributes (ATK, MAG, SPR), and growth metrics.
* **game_stats.json**: Live session data, including current boss HP, wave progress, and party unit details.

### 3. OBS Browser Sources
Live examples of how this data can be visualized can be found here: [https://enzemo.github.io/Ffbot-IDLE-Mods/](https://enzemo.github.io/Ffbot-IDLE-Mods/) 

---

## Installation and Setup

### Local Configuration
1. Place `game-stats-browser.html`, `player-stats-browser.html`, and `index.html` into the same folder as your game executable.
2. Ensure `gameover.wav` is present in that same directory for audio alerts.

### OBS Integration
1. Add a new **Browser Source** in OBS.
2. Check the **Local File** box and browse to the desired HTML file.
3. Recommended dimensions:
    * **Game Stats Overlay**: 450 Width x 650 Height
    * **Player Stats Overlay**: 380 Width x 550 Height
4. Enable **Refresh browser when source becomes active**.

---

## Technical Data Points

### Player Profile Data
* **Base Attributes**: Monitors HP, Level, Attack, Magic, and Spirit.
* **Progression**: Tracks Ascension levels, Awakening EXP, and total wins.
* **Passive Roadmap**: Shows wins required for upcoming slot unlocks (e.g., Slot 1 at 100 wins).
* **Collection**: Monitors total items discovered (out of 129).

### Live Session Data
* **World State**: Displays Season, Cycle, Stage, Tier, and NG+ modifiers.
* **Battle Progress**: Live tracking of Boss Name (e.g., Sweeper), Boss HP, and Wave completion percentage.
* **Hire System**: Displays the currently available Hire (e.g., Vivi) and their price.
* **Party Status**: Real-time ATB, LB Charge, and Status Effects for all active units.

## Project Structure
* `index.html`: Central directory for the overlays.
* `game-stats-browser.html`: Live battle and session overlay.
* `player-stats-browser.html`: Persistent character attribute overlay.
* `player_stats.json`: Sample output of player data.
* `game_stats.json`: Sample output of session data.
* `gameover.wav`: Required file fo r audio alerts.
