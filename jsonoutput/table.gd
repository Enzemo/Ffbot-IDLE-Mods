
## Insert into table.gd, do not replace
## Obviously requires Elbody's source code
## Find it yourself

##  make sure you insert the update_game_stats() function in func set_table(actorlist):
## example:
	# Update UI elements immediately
	#update_battle_ui()
	#
	# --- THIS IS THE CALL TO THE JSON WRITER ---
	#update_game_stats()
	#
	#metuba_check()

## if you cannot find this, open an issue or download the latest release
## unpack and verify the table.md against your own

# Variable for the writer node
@onready var game_stats_writer = $"../game_stats_writer"

# Function to gather data and trigger the writer
func update_game_stats():
	if game_stats_writer:
		# Use safe fallbacks for potentially null values
		var safe_boss_name = enemydatabase.bossname if enemydatabase and enemydatabase.bossname else "None"
		var safe_cycle = tiertracker.cycle if tiertracker else 1
		var safe_player_count = playeramount
		
		# Calls the external script to handle JSON generation
		game_stats_writer.update_all_game_stats(
			battle_ongoing, 
			current_wave, 
			total_waves, 
			safe_player_count, 
			safe_boss_name, 
			safe_cycle, 
			self
		)
		print("DEBUG: Successfully called update_all_game_stats with JSON data")
	else:
		print("DEBUG: game_stats_writer not found!")
