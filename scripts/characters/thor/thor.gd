extends CharacterBody2D

const TILE_SIZE := 32

# Map boundaries in pixels
const LEFT_BOUNDARY := 368.0
const RIGHT_BOUNDARY := 16.0
const TOP_BOUNDARY := 44.0
const BOTTOM_BOUNDARY := 209.0

var moving := false
var target_position := Vector2.ZERO
var directional_direction := Vector2.ZERO
var last_direction := Vector2.DOWN


func _physics_process(_delta: float) -> void:
	if moving:
		# Move toward the next tile.
		global_position = global_position.move_toward(target_position, 8.0)

		if global_position == target_position:
			global_position = target_position
			moving = false

			# Player has finished moving, so every enemy gets one turn.
			var enemies := get_tree().get_nodes_in_group("Enemy")

			for enemy in enemies:
				enemy.take_turn()

		return

	# Only accept a new button press when standing still.
	var direction := Vector2.ZERO

	if Input.is_action_just_pressed("ui_left"):
		$Animation.flip_h = true
		$Animation.play("IdleSide")
		direction = Vector2.LEFT

	elif Input.is_action_just_pressed("ui_right"):
		$Animation.flip_h = false
		$Animation.play("IdleSide")
		direction = Vector2.RIGHT

	elif Input.is_action_just_pressed("ui_up"):
		$Animation.play("IdleUp")
		direction = Vector2.UP

	elif Input.is_action_just_pressed("ui_down"):
		$Animation.play("IdleDown")
		direction = Vector2.DOWN

	if direction != Vector2.ZERO:
		directional_direction = direction
		last_direction = direction

		# Calculate the position after moving exactly 1 tile (32 pixels).
		var next_position := global_position + direction * TILE_SIZE

		# Make sure the NEXT position will still be inside the map.
		var is_in_boundaries := (
			next_position.x >= RIGHT_BOUNDARY
			and next_position.x <= LEFT_BOUNDARY
			and next_position.y >= TOP_BOUNDARY
			and next_position.y <= BOTTOM_BOUNDARY
		)

		# Only move if the next position is inside the boundaries.
		if is_in_boundaries:
			target_position = next_position
			moving = true
