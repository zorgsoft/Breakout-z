extends Node2D

var score = 0 setget set_score

onready var paddle = get_node('Paddle')

# Load level data on Main ready
# -----------------------------------------------------------------------------
func _ready():
	var ball_start_x = get_viewport().get_rect().size.x / 2
	var ball_start_y = paddle.get_global_pos().y - (paddle.get_node('Sprite').get_item_rect().size.height / 2)
	
	# Load level 0
	Levels.level_load(0)
	# Create new ball
	Levels.ball_add(Vector2(ball_start_x, ball_start_y), Vector2(200, -200))
	
	get_viewport().connect("size_changed", self, "window_resize")
	
	set_process_input(true)

# On input
# -----------------------------------------------------------------------------
func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Set new score
# -----------------------------------------------------------------------------
func set_score(score_add):
	var score_label = get_node('UIContainer/ScoreLabel')
	score += score_add
	score_label.set_text('Score: ' + str(score))

# On window resize
# -----------------------------------------------------------------------------
func window_resize():
	# paddle.update_limits()
	pass
