# Ffbot-IDLE-Mods (v9.01)
Mods for Elbody's [FFBot Idle Game](https://elbody.itch.io/ffbot).

**Disclaimer:** These mods modify core game files. Use may result in a leaderboard ban. **Always back up your original `ffbot.pck` before starting.**

## New in v9.01
- **Audio Alerts**: Automatically plays `gameover.wav` on game over.
- **Live Data**: Generates `player_stats.json` and `game_stats.json` for stream overlays.
- **Compatibility**: Updated for FFBot v9.01.

## Manual Integration Instructions
If you are not using a pre-compiled release, follow these steps to integrate the code manually:

1. **Extract**: Use [Godot PCK Explorer](https://dmitriysalnikov.itch.io/godot-pck-explorer) to extract the contents of the original `ffbot.pck`.
2. **Add Writer**: Place `game_stats_writer.gd` into the `example/` folder of the extracted directory.
3. **Edit Code**: Open `table.gd` and inject the mod logic into the appropriate locations (refer to the source files in this repo for exact hooks).
4. **Re-pack**: Use PCK Explorer to "Pack from Folder."
5. **Install**: Replace the `ffbot.pck` in your game directory with your new version.
6. **Verify**: Run the game and attempt to use `!start`. 
    - **Note**: If battles do not start correctly, the code was likely placed in the wrong section of `table.gd`.

## Setup
- **Audio**: Place your chosen `gameover.wav` in the same folder as the game `.exe`.
- **Overlays**: The JSON files are generated in the same directory as the executable.

## OBS Browser Sources
Add these as **Browser Sources** (Check "Local File"):
- **[Game Stats](game-stats-browser.html)**: 450x650 (Boss HP, Wave Progress, Party Status)
- **[Player Stats](player-stats-browser.html)**: 380x550 (Attributes, Passive Roadmap, Collection)

Live Preview: [https://enzemo.github.io/Ffbot-IDLE-Mods/](https://enzemo.github.io/Ffbot-IDLE-Mods/)
