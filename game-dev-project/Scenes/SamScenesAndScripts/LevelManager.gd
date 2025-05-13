extends Node
# C:\Users\adm1\AppData\Roaming\Godot\app_userdata\Game Dev Project
const SAVE_FILE := "user://level_progress.save"

var unlocked_levels := {
	"level1": true,  # First level is always unlocked
	"level2": false,
	"level3": false,
	"gamecomplete": false
}

func _ready():
	load_progress()

func save_progress():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(unlocked_levels)
		file.close()

func load_progress():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var data = file.get_var()
			if data is Dictionary:
				unlocked_levels = data
			file.close()

func unlock_level(level_name: String):
	if unlocked_levels.has(level_name):
		unlocked_levels[level_name] = true
		save_progress()

func is_level_unlocked(level_name: String) -> bool:
	return unlocked_levels.get(level_name, false)

func reset_progress():
	unlocked_levels = {
		"level1": true,
		"level2": false,
		"level3": false,
		"gamecomplete": false
	}
	save_progress()
	
func print_level_status():
	print("=== LEVEL UNLOCK STATUS ===")
	for level in unlocked_levels:
		var status = "UNLOCKED" if unlocked_levels[level] else "LOCKED"
		print("%s: %s" % [level, status])
	print("==========================")
