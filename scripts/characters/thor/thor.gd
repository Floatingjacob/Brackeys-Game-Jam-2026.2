extends CharacterBody2D
const SPEED = 300.0
const MovementSnap: Vector2 = Vector2(16, 16)

var directionalDirection := Vector2(0, 0)
var lastDirectionalDirectionAxis := 1 # 1 = x, 0 = y

func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	var pos = Vector2(int(global_position.x) % int(MovementSnap.x), int(global_position.y) % int(MovementSnap.y))
	
	if direction.x != 0: directionalDirection.x = direction.x
	if direction.y != 0: directionalDirection.y = direction.y
	
	if direction.x != 0 || pos.x != 0: 
		lastDirectionalDirectionAxis = 1
		velocity.x = directionalDirection.x * SPEED
		velocity.y = 0 # No diagonal movement
	else: 
		$Animation.flip_h = directionalDirection.x < 0
		if $Animation.animation != "IdleSide" && lastDirectionalDirectionAxis == 1: 
			$Animation.play("IdleSide")
		velocity.x = 0
	
	if direction.y != 0 || pos.y != 0:
		lastDirectionalDirectionAxis = 0
		velocity.y = directionalDirection.y * SPEED
		velocity.x = 0 # No diagonal movement
	else:
		velocity.y = 0

		if lastDirectionalDirectionAxis == 0:
			if directionalDirection.y < 0:
				if $Animation.animation != "IdleUp":
					$Animation.play("IdleUp")
			else:
				if $Animation.animation != "IdleDown":
					$Animation.play("IdleDown")
	move_and_slide()
