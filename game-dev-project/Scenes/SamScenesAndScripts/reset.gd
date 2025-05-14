extends Node

func _ready():
	# Change these values here, reset save data
	var data = {
		"level1": false,
		"level2": false,
		"level3": false,
	}
	
	var file = FileAccess.open("user://level_progress.save", FileAccess.WRITE)
	file.store_var(data)
	file.close()
	print("Save file modified!")
	LevelManager.print_level_status()
