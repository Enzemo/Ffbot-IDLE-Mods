# in func ascension(name):
# put this under call_text(message)

# Generate ascend stats JSON for failed requirements
		var new_stats_dict = {
			"newatk": 0,
			"newspi": 0,
			"newmag": 0,
			"newhp": 0
		}
		
		if game_stats_writer:
			game_stats_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)
		else:
			# Fallback: try to find the node dynamically
			var fallback_writer = get_node_or_null("../game_stats_writer")
			if fallback_writer:
				fallback_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)
			else:
				# Try another common path
				fallback_writer = get_node_or_null("%game_stats_writer")
				if fallback_writer:
					fallback_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)


            
#
#
#
#
            
# put this after ### CALCULATE 25%
#	atk = int(atk*0.55)
#	spi = int(spi*0.55)
#	mag = int(mag*0.55)
#	hp = int(hp*0.55)
#	newatk = atk
#	newspi = spi
#	newmag = mag
#	newhp = hp

# Generate ascend stats JSON
	var new_stats_dict = {
		"newatk": newatk,
		"newspi": newspi,
		"newmag": newmag,
		"newhp": newhp
	}
	
	if game_stats_writer:
		game_stats_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)
	else:
		# Fallback: try to find the node dynamically
		var fallback_writer = get_node_or_null("../game_stats_writer")
		if fallback_writer:
			fallback_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)
		else:
			# Try another common path
			fallback_writer = get_node_or_null("%game_stats_writer")
			if fallback_writer:
				fallback_writer.write_ascend_stats_json(name, playerdatabase, table, tiertracker, new_stats_dict)



#
#
#put in func freehire_set(nmame):

# Output JSON file with freehire and playername
		if game_stats_writer:
			game_stats_writer.write_freehire_json(name, freehire)
		else:
			# Fallback: try to find the node dynamically
			var fallback_writer = get_node_or_null("../game_stats_writer")
			if fallback_writer:
				fallback_writer.write_freehire_json(name, freehire)
			else:
				# Try another common path
				fallback_writer = get_node_or_null("%game_stats_writer")
				if fallback_writer:
					fallback_writer.write_freehire_json(name, freehire)
