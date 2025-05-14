extends Node

func _ready():
	# Change these values here, reset save data
	var data = {
		"level1": true,
		"level2": true,
		"level3": true,
	}
	
	var file = FileAccess.open("user://level_progress.save", FileAccess.WRITE)
	file.store_var(data)
	file.close()
	print("Save file modified!")
	LevelManager.print_level_status()
