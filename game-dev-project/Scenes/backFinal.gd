extends CanvasLayer

# STAR BACKGROUND
@onready var star1 = $sky1
@onready var star2 = $sky2

# ROCK BACKGROUND
@onready var rock1 = $rock1
@onready var rock2 = $rock2

# MOUNTAIN BACKGROUND
@onready var mountain1 = $mountain1
@onready var mountain2 = $mountain2

# BIP BACKGROUND
@onready var bip1 = $bip1
@onready var bip2 = $bip2

# BOP BACKGROUND
@onready var bop1 = $bop1
@onready var bop2 = $bop2  # Fixed: was pointing to bop1 again

# WOOD BACKGROUND
@onready var wood1 = $wood1
@onready var wood2 = $wood2

# GROUND BACKGROUND
@onready var ground1 = $ground1
@onready var ground2 = $ground2

# THREE BACKGROUND
@onready var three1 = $three1
@onready var three2 = $three2

# SPEEDS
const STAR_SPEED := 20
const ROCK_SPEED := 40
const MOUNTAIN_SPEED := 100
const BIP_SPEED := 200
const BOP_SPEED := 250
const WOOD_SPEED := 300
const GROUND_SPEED := 400
const THREE_SPEED := 500

# TELEPORTATION VALUES
const TELEPORT_TRIGGER_X := -817
const TELEPORT_TO_X := 2418

func _process(delta):
	move_and_teleport(star1, delta, STAR_SPEED)
	move_and_teleport(star2, delta, STAR_SPEED)

	move_and_teleport(rock1, delta, ROCK_SPEED)
	move_and_teleport(rock2, delta, ROCK_SPEED)

	move_and_teleport(mountain1, delta, MOUNTAIN_SPEED)
	move_and_teleport(mountain2, delta, MOUNTAIN_SPEED)

	move_and_teleport(bip1, delta, BIP_SPEED)
	move_and_teleport(bip2, delta, BIP_SPEED)

	move_and_teleport(bop1, delta, BOP_SPEED)
	move_and_teleport(bop2, delta, BOP_SPEED)

	move_and_teleport(wood1, delta, WOOD_SPEED)
	move_and_teleport(wood2, delta, WOOD_SPEED)

	move_and_teleport(ground1, delta, GROUND_SPEED)
	move_and_teleport(ground2, delta, GROUND_SPEED)

	move_and_teleport(three1, delta, THREE_SPEED)
	move_and_teleport(three2, delta, THREE_SPEED)

func move_and_teleport(sprite: Node2D, delta: float, speed: float) -> void:
	sprite.position.x -= speed * delta
	if sprite.position.x <= TELEPORT_TRIGGER_X:
		sprite.position.x = TELEPORT_TO_X
