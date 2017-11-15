extends KinematicBody2D

export (int) var MOVE_SPEED = 2

var position = Vector2()

export (int) var move_limit_left = 128
export (int) var move_limit_right = -128
var calculated_move_limit_left
var calculated_move_limit_right

var input_pos = Vector2(0, 0)


func _ready():
	update_limits()
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.SCREEN_TOUCH:
		input_pos = event.pos

func _fixed_process(delta):
	var paddle_x = get_pos().x
	var mouse_x = input_pos.x

	position.x += (mouse_x - paddle_x) * MOVE_SPEED * delta
	position.y = get_pos().y
	
	if position.x <= calculated_move_limit_left:
		position.x = calculated_move_limit_left
	if position.x >= calculated_move_limit_right:
		position.x = calculated_move_limit_right
	
	set_pos(position)

func update_limits():
	var sprite_width = get_node("Sprite").get_texture().get_width()
	
	calculated_move_limit_left = move_limit_left + sprite_width
	calculated_move_limit_right = get_viewport_rect().size.width - sprite_width + move_limit_right
	print(calculated_move_limit_right)
