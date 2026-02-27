extends Node

# File writer for game statistics
# Creates separate text files for player count, current boss, and NG+ attempts

func _ready():
	# Test file writing on startup
	test_file_writing()

func test_file_writing():
	print("Testing file writing...")
	
	# Test JSON generation with dummy data
	test_json_generation()
	
	print("File writing test completed")

func test_json_generation():
	print("Testing JSON generation...")
	
	var test_data = {
		"timestamp": Time.get_datetime_string_from_system(),
		"game_info": {
			"players_in_run": 4,
			"current_boss": "TestBoss",
			"ng_plus_attempt": 42,
			"season": 1,
			"cycle": 42,
			"stage": 1,
			"tier": 5
		},
		"battle_info": {
			"player_amount": 4,
			"enemy_amount": 3,
			"battle_ongoing": true,
			"current_turn": 7
		},
		"player_stats": [
			{
				"slot": 1,
				"name": "TestPlayer",
				"hp_current": 8500,
				"hp_max": 9999,
				"hp_percent": 85,
				"status": [],
				"lb_charge": 85,
				"atb": 1200
			}
		],
		"enemy_stats": [
			{
				"slot": 100,
				"name": "TestBoss",
				"hp_current": 45000,
				"hp_max": 60000,
				"hp_percent": 75,
				"status": [],
				"stagger_type": "mag"
			}
		],
		"system_info": {
			"esper_system": true,
			"card_system": false,
			"materia_system": true,
			"job_system": true,
			"artifact_system": false
		},
		"stream_info": {
			"channel_name": "test_channel",
			"game_version": "9.01",
			"uptime": "02:15:30"
		}
	}
	
	var json_string = JSON.stringify(test_data, "\t")
	print("DEBUG: Test JSON string length: ", json_string.length())
	
	# Write to user:// first
	var file = FileAccess.open("user://game_stats.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Test JSON written to user://")
		
		# Copy to game directory
		copy_json_to_game_dir(json_string)
	else:
		print("Failed to open user://game_stats.json for writing test")

# Text file generation functions removed - JSON only



# Text file copy function removed - JSON only

# Write comprehensive game stats as JSON
func write_game_stats_json(player_count: int, boss_name: String, attempt_number: int, table_node):
	print("Writing comprehensive game stats JSON...")
	
	# Get tiertracker reference for game series info
	var tiertracker = null
	if table_node and table_node.has_method("get") and table_node.get("tiertracker"):
		tiertracker = table_node.tiertracker
	
	# Get current battle state
	var battle_ongoing = false
	var current_wave = 0
	var max_waves = 50
	var battle_time = "00:00:00"
	var playeramount = player_count
	
	if table_node:
		battle_ongoing = table_node.get("battle_ongoing", false)
		current_wave = table_node.get("current_wave", 0)
		max_waves = table_node.get("total_waves", 50)
		playeramount = table_node.get("playeramount", player_count)
		if table_node.has_method("get_time_since_last_game_over"):
			battle_time = table_node.get_time_since_last_game_over()
	
	# Get game series information
	var season = 1
	var cycle = attempt_number
	var tier = 1
	var stage = 1
	var ng_plus_display = attempt_number + 1  # NG+ starts at 0, display starts at 1
	
	if tiertracker:
		season = tiertracker.get("season", 1)
		cycle = tiertracker.get("cycle", attempt_number)
		tier = tiertracker.get("tier", 1)
		stage = tiertracker.get("stage", 1)
		ng_plus_display = tiertracker.get("cycle", attempt_number) + 1  # NG+ starts at 0, display starts at 1
	
	# Get system information
	var esper_system = false
	var card_system = false
	var job_system = false
	var artifact_system = false
	var passive_system = false
	
	if table_node:
		esper_system = table_node.get("esper_system", false)
		card_system = table_node.get("card_system", false)
		job_system = table_node.get("job_system", false)
		artifact_system = table_node.get("artifact_system", false)
		passive_system = table_node.get("passive_system", false)
	
	# Get current actors/enemies information
	var actorlist_ready = {}
	var enemy_count = 0
	var boss_hp_current = 0
	var boss_hp_max = 0
	var current_passive = ""
	var available_characters = []
	var current_hire = "None"
	var hire_price = 0
	
	if table_node:
		actorlist_ready = table_node.get("actorlist_ready", {})
		enemy_count = actorlist_ready.size()
		
		# Get boss HP if available
		if actorlist_ready.has(100):
			var boss_data = actorlist_ready[100]
			boss_hp_current = boss_data.get("hp", 0)
			boss_hp_max = boss_data.get("hpmax", 0)
		
		# Get current run information
		current_passive = table_node.get("current_passive", "")
		available_characters = table_node.get("available_characters", [])
		current_hire = table_node.get("hire", "None")
		hire_price = table_node.get("hire_price", 0)
		
		# Get passive information from tiertracker if passive system is active
		if table_node.get("passive_system", false) and tiertracker:
			current_passive = tiertracker.get("passive", "")
			
			# If still empty, try to get from table_node as fallback
			if current_passive == "":
				current_passive = table_node.get("current_passive", "")
				
			# Final fallback: check if any player has a passive assigned
			if current_passive == "":
				for player_slot in range(1, 12):  # Players 1-11
					if actorlist_ready.has(player_slot):
						var player_data = actorlist_ready[player_slot]
						if player_data.has("passive") and player_data["passive"] != "":
							current_passive = player_data["passive"]
							break
	
	# Create comprehensive JSON data
	var json_data = {
		"timestamp": Time.get_datetime_string_from_system(),
		"unix_timestamp": Time.get_unix_time_from_system(),
		
		"game_info": {
			"players_in_run": playeramount,
			"current_boss": boss_name,
			"ng_plus_attempt": ng_plus_display,  # Corrected: starts at 1 instead of 0
			"ng_plus_internal": attempt_number,  # Internal counter (starts at 0)
			"season": season,
			"cycle": cycle,
			"stage": stage,
			"tier": tier
		},
		
		"wave_info": {
			"current_wave": current_wave,
			"max_waves": max_waves,
			"wave_progress_percent": 0 if max_waves == 0 else int((float(current_wave) / float(max_waves)) * 100),
			"waves_remaining": max(0, max_waves - current_wave)
		},
		
		"battle_info": {
			"battle_ongoing": battle_ongoing,
			"battle_time": battle_time,
			"enemy_count": enemy_count,
			"player_count": playeramount,
			"boss_hp_current": boss_hp_current,
			"boss_hp_max": boss_hp_max,
			"boss_hp_percent": 0 if boss_hp_max == 0 else int((float(boss_hp_current) / float(boss_hp_max)) * 100)
		},
		
		"system_info": {
			"esper_system": esper_system,
			"card_system": card_system,
			"job_system": job_system,
			"artifact_system": artifact_system,
			"passive_system": passive_system
		},
		
		"actor_info": {
			"total_actors": actorlist_ready.size(),
			"actor_slots": actorlist_ready.keys(),
			"has_boss": actorlist_ready.has(100)
		},
		
		"progression": {
			"completion_rate": 0 if max_waves == 0 else int((float(current_wave) / float(max_waves)) * 100),
			"is_final_wave": current_wave >= max_waves,
			"waves_until_complete": max(0, max_waves - current_wave)
		},
		
		"run_info": {
			"current_passive": current_passive,
			"available_characters": available_characters,
			"hire_system": {
				"current_hire": current_hire,
				"hire_price": hire_price,
				"hire_available": current_hire != "None"
			},
			"passive_system_active": table_node.get("passive_system", false) if table_node else false
		},
		
		"player_details": []
	}
	
	# Add detailed player information
	if table_node:
		for player_slot in range(1, 12):  # Players 1-11
			if actorlist_ready.has(player_slot):
				var player_data = actorlist_ready[player_slot]
				var player_info = {
					"slot": player_slot,
					"name": player_data.get("name", "Unknown"),
					"unit": player_data.get("unit", "Unknown"),
					"hp_current": player_data.get("hp", 0),
					"hp_max": player_data.get("hpmax", 0),
					"hp_percent": 0 if player_data.get("hpmax", 0) == 0 else int((float(player_data.get("hp", 0)) / float(player_data.get("hpmax", 0))) * 100),
					"passive": player_data.get("passive", ""),
					"card": player_data.get("card", ""),
					"esper": player_data.get("esper", ""),
					"job": player_data.get("job", ""),
					"lb_charge": player_data.get("lb", 0),
					"atb": player_data.get("atb", 0),
					"status_effects": player_data.get("status", [])
				}
				json_data["player_details"].append(player_info)
	
	var json_string = JSON.stringify(json_data, "\t")
	print("DEBUG: Comprehensive JSON string length: ", json_string.length())
	
	# Write to user:// first
	var file = FileAccess.open("user://game_stats.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Comprehensive game stats JSON written to user://")
		
		# Copy to game directory
		copy_json_to_game_dir(json_string)
	else:
		print("Failed to open user://game_stats.json for writing")

func copy_json_to_game_dir(json_string: String):
	var dest_file = FileAccess.open("game_stats.json", FileAccess.WRITE)
	if dest_file:
		dest_file.store_string(json_string)
		dest_file.close()
		print("Copied game_stats.json to game directory")
	else:
		print("Failed to copy game_stats.json to game directory")

# Simple test function to verify JSON writing works
func test_player_stats_json(player_name: String):
	print("Testing player stats JSON generation for: ", player_name)
	
	var test_data = {
		"timestamp": Time.get_datetime_string_from_system(),
		"unix_timestamp": Time.get_unix_time_from_system(),
		"player_name": player_name,
		"test": true,
		"basic_stats": {
			"level": 1,
			"attack": 100,
			"magic": 50,
			"spirit": 75,
			"hp": 1000
		}
	}
	
	var json_string = JSON.stringify(test_data, "\t")
	
	# Write to user:// first
	var file = FileAccess.open("user://player_stats.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Test player stats JSON written to user://")
		
		# Copy to game directory
		copy_player_stats_to_game_dir(json_string)
	else:
		print("Failed to open user://player_stats.json for writing")

# Write individual player stats as JSON (for !stats command)
func write_player_stats_json(player_name: String, playerdatabase_node, table_node, tiertracker_node, characterdatabase_node):
	print("Writing player stats JSON for: ", player_name)
	
	# Validate inputs
	if not playerdatabase_node:
		print("Error: playerdatabase_node is null")
		return
	
	if not playerdatabase_node.playerdatabase.has(player_name):
		print("Player not found in database: ", player_name)
		return
	
	var player_data = playerdatabase_node.playerdatabase[player_name]
	var unit = player_data.get("unit", "Unknown")
	
	# Get mastery information
	var mastery_info = {}
	var m1_true = player_data.get("m1", "")
	if m1_true != "":
		mastery_info["m1"] = {
			"name": m1_true,
			"display": m1_true.substr(0,4),
			"level": playerdatabase_node.hire[player_name][m1_true] if playerdatabase_node.hire.has(player_name) and playerdatabase_node.hire[player_name].has(m1_true) else 0,
			"ap": player_data.get("jobap", 0),
			"ap_to_next": (playerdatabase_node.hire[player_name][m1_true] * 20) - player_data.get("jobap", 0) if playerdatabase_node.hire.has(player_name) and playerdatabase_node.hire[player_name].has(m1_true) else 0
		}
	
	# Get passive information
	var passive_info = {}
	if table_node and table_node.get("passive_system", false):
		passive_info["system_active"] = true
		passive_info["available_passives"] = []
		
		# Check for unlocked passives
		var awakening_level = player_data.get("awakeninglv" + unit, 0)
		if characterdatabase_node and characterdatabase_node.characterlist.has(unit):
			var char_data = characterdatabase_node.characterlist[unit]
			
			# Passive 1 (unlocked at 100 wins)
			if awakening_level > 99 and char_data.has("a1"):
				passive_info["available_passives"].append({
					"slot": 1,
					"name": char_data["a1"],
					"unlocked": true,
					"wins_required": 100
				})
			else:
				passive_info["available_passives"].append({
					"slot": 1,
					"name": "Unknown",
					"unlocked": false,
					"wins_required": 100,
					"wins_until_unlock": (awakening_level - 100) * (-1)
				})
			
			# Passive 2 (unlocked at 200 wins)
			if awakening_level > 199 and char_data.has("a2"):
				passive_info["available_passives"].append({
					"slot": 2,
					"name": char_data["a2"],
					"unlocked": true,
					"wins_required": 200
				})
			else:
				passive_info["available_passives"].append({
					"slot": 2,
					"name": "Unknown", 
					"unlocked": false,
					"wins_required": 200,
					"wins_until_unlock": (awakening_level - 200) * (-1)
				})
			
			# Passive 3 (unlocked at 500 wins, Season 5 finale)
			if playerdatabase_node.playerdatabase["metadata"].has("s5finale"):
				if awakening_level > 499 and char_data.has("a3"):
					passive_info["available_passives"].append({
						"slot": 3,
						"name": char_data["a3"],
						"unlocked": true,
						"wins_required": 500
					})
				else:
					passive_info["available_passives"].append({
						"slot": 3,
						"name": "Unknown",
						"unlocked": false,
						"wins_required": 500,
						"wins_until_unlock": (awakening_level - 500) * (-1)
					})
			
			# Season 5 passive
			if tiertracker_node and tiertracker_node.get("season", 0) == 5 and player_data.has("ps5" + unit):
				passive_info["season5_passive"] = player_data["ps5" + unit]
	else:
		passive_info["system_active"] = false
	
	# Get artifact information
	var artifact_info = {}
	if table_node and table_node.get("artifact_system", false):
		artifact_info["system_active"] = true
		artifact_info["equipped"] = player_data.get("artifact", "")
		artifact_info["bonuses"] = {
			"hp": player_data.get("arti_hp", 0),
			"atk": player_data.get("arti_atk", 0),
			"mag": player_data.get("arti_mag", 0),
			"spi": player_data.get("arti_spi", 0)
		}
	else:
		artifact_info["system_active"] = false
	
	# Get card information
	var card_info = {}
	if table_node and table_node.get("card_system", false):
		card_info["system_active"] = true
		card_info["equipped"] = player_data.get("card", "")
		card_info["passive"] = player_data.get("card_passive", "")
	else:
		card_info["system_active"] = false
	
	# Get esper information
	var esper_info = {}
	if table_node and table_node.get("esper_system", false):
		esper_info["system_active"] = true
		esper_info["equipped"] = player_data.get("esper", "")
	else:
		esper_info["system_active"] = false
	
	# Calculate collection progress
	var collection_total = tiertracker_node.general_pool.size() if tiertracker_node else 0
	var collection_progress = {
		"collected": player_data.get("collection", 0),
		"total": collection_total,
		"percentage": int((float(player_data.get("collection", 0)) / float(collection_total)) * 100) if collection_total > 0 else 0
	}
	
	# Create comprehensive player stats JSON
	var player_stats_data = {
		"timestamp": Time.get_datetime_string_from_system(),
		"unix_timestamp": Time.get_unix_time_from_system(),
		"player_name": player_name,
		
		"basic_stats": {
			"level": player_data.get("lv", 0),
			"attack": player_data.get("atk", 0),
			"magic": player_data.get("mag", 0),
			"spirit": player_data.get("spi", 0),
			"hp": player_data.get("hp", 0),
			"preferred_stat": player_data.get("preferedstat", "none"),
			"wins": player_data.get("wins", 0)
		},
		
		"character_info": {
			"unit": unit,
			"ascension_level": player_data.get("ascension", 0),
			"ascension_exp_bonus": player_data.get("ascension", 0) * 2,
			"awakening_exp": player_data.get("awakeningexp", 0),
			"awakening_level_specific": player_data.get("awakeninglv" + unit, 0)
		},
		
		"collection": collection_progress,
		
		"free_hire": {
			"available": player_data.get("freehirecount", 0) > 49,
			"current_count": player_data.get("freehirecount", 0),
			"wins_until_available": max(0, 50 - player_data.get("freehirecount", 0))
		},
		
		"mastery": mastery_info,
		"passives": passive_info,
		"artifacts": artifact_info,
		"cards": card_info,
		"espers": esper_info
	}
	
	var json_string = JSON.stringify(player_stats_data, "\t")
	print("DEBUG: Player stats JSON string length: ", json_string.length())
	
	# Write to user:// first
	var file = FileAccess.open("user://player_stats.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Player stats JSON written to user:// for player: ", player_name)
		
		# Copy to game directory
		copy_player_stats_to_game_dir(json_string)
	else:
		print("Failed to open user://player_stats.json for writing")

func copy_player_stats_to_game_dir(json_string: String):
	var dest_file = FileAccess.open("player_stats.json", FileAccess.WRITE)
	if dest_file:
		dest_file.store_string(json_string)
		dest_file.close()
		print("Copied player_stats.json to game directory")
	else:
		print("Failed to copy player_stats.json to game directory")

# Update all game stats with comprehensive information (JSON only)
func update_all_game_stats(player_count: int, boss_name: String, attempt_number: int, table_node):
	print("Updating all game stats...")
	
	# Write comprehensive JSON only
	write_game_stats_json(player_count, boss_name, attempt_number, table_node)
	
	print("All game stats updated successfully")
