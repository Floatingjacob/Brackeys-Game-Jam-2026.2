extends Camera2D

@export var TopLimit:int = -10000000
@export var BottomLimit:int = 10000000
@export var RightLimit:int = 10000000
@export var LeftLimit:int = -10000000

func _ready() -> void:
	limit_top = TopLimit
	limit_bottom = BottomLimit
	limit_right = RightLimit
	limit_left = LeftLimit
