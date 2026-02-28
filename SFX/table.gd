#Insert this code into your table.gd, before "func test():"
#I will not provide Elbody's full source code myself
#
#If an audio_debug.txt is generated, there was an error loading your sfx.
#Check the text file for more details.
#
#Make sure you add play_game_over_sound() somewhere in the func game_over(): 
#
#i place it after update_battle_ui() 





# Variable to hold the loaded audio resource
var LoadedMusic: AudioStream 

# Helper function to write debug information to a local text file
func write_to_debug_file(text: String):
	var local_dir = OS.get_executable_path().get_base_dir()
	var debug_file_path = local_dir + "/audio_debug.txt"
	var file = FileAccess.open(debug_file_path, FileAccess.READ_WRITE)
	if not file:
		file = FileAccess.open(debug_file_path, FileAccess.WRITE)
	if file:
		file.seek_end()
		file.store_line("[" + Time.get_datetime_string_from_system() + "] " + text)
		file.close()

# Logic to load and play the sound
func play_game_over_sound():
	var local_dir = OS.get_executable_path().get_base_dir()
	var external_path = local_dir + "/gameover.wav"
	var internal_path = "res://assets/sounds/gameover.wav"
	
	# write_to_debug_file("--- New Attempt ---")

	# 1. TRY EXTERNAL FILE (Manual Buffer Loading)
	if FileAccess.file_exists(external_path):
		var file = FileAccess.open(external_path, FileAccess.READ)
		if file:
			var bytes = file.get_buffer(file.get_length())
			file.close()
			
			var new_stream = AudioStreamWAV.new()
			# Most common WAV format. If it sounds like static, 
			# the WAV might be 32-bit (requires different format setting).
			new_stream.format = AudioStreamWAV.FORMAT_16_BITS
			new_stream.data = bytes
			new_stream.mix_rate = 44100
			new_stream.stereo = true
			
			LoadedMusic = new_stream
			
			var audio_player = AudioStreamPlayer.new()
			get_tree().current_scene.add_child(audio_player)
			audio_player.stream = LoadedMusic
			audio_player.play()
			
			# write_to_debug_file("SUCCESS: Playing external WAV via Buffer.")
			
			await audio_player.finished
			audio_player.queue_free()
			return

	# 2. FALLBACK TO INTERNAL (load() works here because it's inside the PCK)
	if ResourceLoader.exists(internal_path):
		var internal_res = load(internal_path)
		if internal_res:
			if video_stream_player:
				video_stream_player.set_stream(internal_res)
				video_stream_player.play()
				write_to_debug_file("SUCCESS: Playing internal asset.")
	else:
		write_to_debug_file("ERROR: No files found.")

# Logic to play the Ragtime Mouse appearance sound
func play_ragtime_appearance_sound():
	var local_dir = OS.get_executable_path().get_base_dir()
	var external_path = local_dir + "/ragtime.wav"
	var internal_path = "res://assets/sounds/ragtime.wav"
	
	# 1. TRY EXTERNAL FILE
	if FileAccess.file_exists(external_path):
		var file = FileAccess.open(external_path, FileAccess.READ)
		if file:
			var bytes = file.get_buffer(file.get_length())
			file.close()
			
			var new_stream = AudioStreamWAV.new()
			new_stream.format = AudioStreamWAV.FORMAT_16_BITS 
			new_stream.data = bytes
			new_stream.mix_rate = 44100
			new_stream.stereo = true
			
			var audio_player = AudioStreamPlayer.new()
			get_tree().current_scene.add_child(audio_player)
			audio_player.stream = new_stream
			audio_player.play()
			
			await audio_player.finished
			audio_player.queue_free()
			return

	# 2. FALLBACK TO INTERNAL
	if ResourceLoader.exists(internal_path):
		var internal_res = load(internal_path)
		if internal_res:
			var audio_player = AudioStreamPlayer.new()
			get_tree().current_scene.add_child(audio_player)
			audio_player.stream = internal_res
			audio_player.play()
			await audio_player.finished
			audio_player.queue_free()
