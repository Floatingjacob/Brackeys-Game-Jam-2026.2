extends CharacterBody2D

const TILE_SIZE := 32

#Fist Spawners
@onready var down_spawner: Node2D = $DownSpawner
@onready var left_spawner: Node2D = $LeftSpawner
@onready var right_spawner: Node2D = $RightSpawner
@onready var up_spawner: Node2D = $UpSpawner

var is_attacking := false
#Fist Scene
var fist_scene: PackedScene = preload("res://scenes/Fist.tscn")

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
#Look for Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true

		attack()

		var enemies := get_tree().get_nodes_in_group("Enemy")

		for enemy in enemies:
			enemy.take_turn()

		await get_tree().create_timer(1.6).timeout

		is_attacking = false
#Movement Code
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

#Function attack
func attack() -> void:
	var spawner: Node2D

	match last_direction:
		Vector2.DOWN:
			spawner = down_spawner
		Vector2.LEFT:
			spawner = left_spawner
		Vector2.RIGHT:
			spawner = right_spawner
		Vector2.UP:
			spawner = up_spawner

	# Wait before spawning the fist.
	await get_tree().create_timer(0.1).timeout

	var fist_instance := fist_scene.instantiate()
	get_parent().add_child(fist_instance)

	fist_instance.global_position = spawner.global_position
