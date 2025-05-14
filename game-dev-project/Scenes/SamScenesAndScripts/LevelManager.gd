extends Node
# C:\Users\adm1\AppData\Roaming\Godot\app_userdata\Game Dev Project
const SAVE_FILE := "user://level_progress.save"

var unlocked_levels := {
	"level1": false,  # First level is always unlocked
	"level2": false,
	"level3": false,
}

func _ready():
	load_progress()

func save_progress():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(unlocked_levels)
		file.close()
	print("Progress saved!")
	print_level_status()

func load_progress():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var data = file.get_var()
			if data is Dictionary:
				unlocked_levels = data
			file.close()

func level_done(level_name: String):
	if unlocked_levels.has(level_name):
		unlocked_levels[level_name] = true
		save_progress()

func is_level_done(level_name: String) -> bool:
	return unlocked_levels.get(level_name, false)

func reset_progress():
	print("Resetting all progress...")
	unlocked_levels = {
		"level1": false,
		"level2": false,
		"level3": false,
	}
	save_progress()
	
func print_level_status():
	print("=== LEVEL STATUS ===")
	print("Level 1: %s" % ["DONE" if unlocked_levels["level1"] else "NOT DONE"])
	print("Level 2: %s" % ["DONE" if unlocked_levels["level2"] else "NOT DONE"])
	print("Level 3: %s" % ["DONE" if unlocked_levels["level3"] else "NOT DONE"])
	print("==========================")
