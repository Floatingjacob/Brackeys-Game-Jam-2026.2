extends CharacterBody2D

const TILE_SIZE := 32

var moving := false
var target_position := Vector2.ZERO
var player: CharacterBody2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(_delta: float) -> void:
	if moving:
		global_position = global_position.move_toward(target_position, 8.0)

		if global_position == target_position:
			global_position = target_position
			moving = false


func take_turn() -> void:
	if moving:
		return

	var difference := player.global_position - global_position
	var direction := Vector2.ZERO

	# Decide whether to move horizontally or vertically.
	if abs(difference.x) > abs(difference.y):
		direction.x = sign(difference.x)
	else:
		direction.y = sign(difference.y)

	# Set the animation based on the direction.
	if direction == Vector2.LEFT:
		$Animation.flip_h = true
		$Animation.play("IdleSide")

	elif direction == Vector2.RIGHT:
		$Animation.flip_h = false
		$Animation.play("IdleSide")

	elif direction == Vector2.UP:
		$Animation.play("IdleDown")

	elif direction == Vector2.DOWN:
		$Animation.play("IdleUp")

	# Move exactly one tile.
	target_position = global_position + direction * TILE_SIZE
	moving = true
