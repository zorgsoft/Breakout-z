extends KinematicBody2D

export (int) var MOVE_SPEED = 2
var position = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var paddle_x = get_pos().x
	var mouse_x = get_viewport().get_mouse_pos().x
	position.x += (mouse_x - paddle_x) * MOVE_SPEED * delta
	position.y = get_pos().y
	set_pos(position)
