extends Area2D

@export var lifetime := 0.5
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.queue_free()
