extends Node2D

const CONTAINER_NAME_BRICKS = 'BricksContainer'
const CONTAINER_NAME_BALLS = 'BallsContainer'

var score = 0 setget set_score

# Level map
var level_map = [
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
	[1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1],
	[1, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 1],
	[1, 0, 0, 0, 0, 3, 0, 3, 3, 0, 3, 0, 0, 0, 0, 1],
	[1, 0, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 0, 0, 0, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 0, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 0, 0, 0, 1],
	[1, 0, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 0, 0, 0, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
]

# Bricks types
var BRICK_TYPES = {
	0: null,
	1: {
		'color': Color(0.6, 0.2, 0.2),
		'hardness': 2,
		'snd_collide': 'brick_collide',
		'snd_destroy': 'brick_destroy'
	},
	3: {
		'color': Color(0, 1, 0),
		'hardness': 1
	}
}

# Level options
var LEVEL_OPTIONS = {
	'START_X': 160,
	'START_Y': 80,
	'STEP_X': 64,
	'STEP_Y': 32
}

# Load level data on Level1 ready
# -----------------------------------------------------------------------------
func _ready():
	var paddle = get_node('Paddle')
	var ball_start_x = get_viewport().get_rect().size.x / 2
	var ball_start_y = paddle.get_global_pos().y - (paddle.get_node('Sprite').get_item_rect().size.height / 2)

	load_level(level_map)
	create_ball(Vector2(ball_start_x, ball_start_y), Vector2(200, -200))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Create new ball
func create_ball(vector_pos, vector_speed):
	var balls_container
	if has_node(CONTAINER_NAME_BALLS):
		balls_container = get_node(CONTAINER_NAME_BALLS)
	else:
		balls_container = Node2D.new()
		add_child(balls_container)
		balls_container.set_name(CONTAINER_NAME_BALLS)

	var new_ball = preload('res://Scenes/Objects/Ball.tscn').instance()
	balls_container.add_child(new_ball)
	new_ball.set_pos(vector_pos)
	new_ball.set_linear_velocity(vector_speed)

# Load level form level_data array
# If clear_level is true, then remove all bricks
# -----------------------------------------------------------------------------
func load_level(level_data, clear_level = true):
	# Remove all bricks if clear_level = true
	var bricks
	if has_node(CONTAINER_NAME_BRICKS):
		bricks = get_node(CONTAINER_NAME_BRICKS)
	else:
		bricks = Node2D.new()
		add_child(bricks)
		bricks.set_name(CONTAINER_NAME_BRICKS)

	if clear_level:
		for brick in bricks.get_children():
			brick.queue_free()

	# Create bricks in "Bricks" node
	for level_line in range(level_data.size()):
		for level_item in range(level_data[level_line].size()):
			var brick_type = BRICK_TYPES[level_data[level_line][level_item]]
			if brick_type != null:
				var new_brick = preload('res://Scenes/Objects/Brick.tscn').instance()
				bricks.add_child(new_brick)
				new_brick.set_pos(Vector2(
					LEVEL_OPTIONS.START_X + (level_item * LEVEL_OPTIONS.STEP_X),
					LEVEL_OPTIONS.START_Y + (level_line * LEVEL_OPTIONS.STEP_Y)
				))
				# Set hardness
				if brick_type.has('hardness') and !str(brick_type.hardness).empty() and brick_type.hardness > 0:
					new_brick.hardness = brick_type.hardness
				new_brick.opacity_dec = 1.0 / new_brick.hardness
				# Set score multiply
				new_brick.score_multiplier = new_brick.hardness
				# Set sound on collide
				if brick_type.has('snd_collide') and !str(brick_type.snd_collide).empty():
					new_brick.snd_collide = brick_type.snd_collide
				# Set sound on destroy
				if brick_type.has('snd_destroy') and !str(brick_type.snd_destroy).empty():
					new_brick.snd_destroy = brick_type.snd_destroy
				# Set color
				if brick_type.has('color') and !str(brick_type.color).empty():
					new_brick.get_node('Sprite').set_modulate(brick_type.color)

func set_score(score_add):
	var score_label = get_node('UIContainer/ScoreLabel')
	score += score_add
	score_label.set_text('Score: ' + str(score))
