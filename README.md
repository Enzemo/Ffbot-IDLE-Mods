# Ffbot-IDLE-Mods
Mods for Elbody's [FFBot Idle Game](https://elbody.itch.io/ffbot)

**Disclaimer:** Use of these mods may or may not ban you from game leaderboards! **Always back up your original `ffbot.pck` and save files before attempting to mod your game.**

## Project Overview
This mod enhances the FFBot experience by providing real-time data exports and audio-visual feedback. It was made possible using the [Godot PCK Explorer](https://dmitriysalnikov.itch.io/godot-pck-explorer).

Currently supports version **9.01** (latest at time of writing). I will attempt to keep this updated alongside game updates, but no promises can be made.

## Installation and Setup

### 1. Install the Mod (.pck)
To apply the mod to your game, you must replace the default game data with the modified version:
1. Go to the [Releases](https://github.com/enzemo/Ffbot-IDLE-Mods/releases) page.
2. Download the latest `.pck` file.
3. Open your FFBot game folder.
4. Replace the existing `.pck` file with the one you just downloaded.

### 2. Manual Integration Instructions
If you are manually adding these features to the game files or updating a custom version:
1. **Extract**: Use [Godot PCK Explorer](https://dmitriysalnikov.itch.io/godot-pck-explorer) to extract the contents of your original `ffbot.pck`.
2. **Add Writer**: Place the `game_stats_writer.gd` file into the `example/` folder of the extracted directory.
3. **Edit Code**: Open `table.gd` and integrate the mod logic into the appropriate functions (refer to the source files in this repo for exact hooks).
4. **Repack**: Use PCK Explorer to "Pack from Folder" to create your new `.pck` file.
5. **Replace**: Replace the existing `ffbot.pck` in your FFBot directory with your modified version.
6. **Verify**: Run the game and attempt to use the `!start` command. 
   - **Note**: If battles do not start correctly, the code has likely been placed in the wrong section of `table.gd`.

### 3. Audio Alerts
* **Game Over SFX**: Plays a sound when hitting a game over. 
* **Requirement**: Include a `gameover.wav` in the same folder as the game executable. You can find an example file in the project releases.

### 4. Data Export (JSON)
Once the mod is running, it will automatically generate two JSON files in the same location as the executable:
* **player_stats.json**: Persistent character data, core attributes (ATK, MAG, SPR), and growth metrics.
* **game_stats.json**: Live session data, including current boss HP, wave progress, and party unit details.

---

## OBS Browser Sources
Live examples of how this data can be visualized can be found here: [https://enzemo.github.io/Ffbot-IDLE-Mods/](https://enzemo.github.io/Ffbot-IDLE-Mods/)

### Integration Steps:
1. Add a new **Browser Source** in OBS.
2. Check the **Local File** box and browse to the desired HTML file (e.g., `game-stats-browser.html`).
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
* **Battle Progress**: Live tracking of Boss Name, Boss HP, and Wave completion percentage.
* **Hire System**: Displays the currently available Hire (e.g., Vivi) and their price.
* **Party Status**: Real-time ATB, LB Charge, and Status Effects for all active units.

## Project Structure
* `index.html`: Central directory for the overlays.
* `game-stats-browser.html`: Live battle and session overlay.
* `player-stats-browser.html`: Persistent character attribute overlay.
* `player_stats.json`: Sample output of player data.
* `game_stats.json`: Sample output of session data.
* `gameover.wav`: Required file for  audio alerts.
