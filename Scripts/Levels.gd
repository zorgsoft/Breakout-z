extends Node

const CONTAINER_NAME_BRICKS = 'BricksContainer'
const CONTAINER_NAME_BALLS = 'BallsContainer'

var _levels_data = [
	[
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

# Load level by level number
# -----------------------------------------------------------------------------
func level_load(level_num, clear = true):
	if _levels_data.size() > level_num:
		_load_level(_levels_data[level_num], clear)
		return true
	else:
		return false

# Load level form level_data array
# If clear_level is true, then remove all bricks
# -----------------------------------------------------------------------------
func _load_level(level_data, clear_level):
	var root = get_tree().get_root().get_node("Main")
	var bricks
	
	if root.has_node(CONTAINER_NAME_BRICKS):
		bricks = root.get_node(CONTAINER_NAME_BRICKS)
	else:
		bricks = Node2D.new()
		root.add_child(bricks)
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

# Create new ball
func ball_add(vector_pos, vector_speed):
	var root = get_tree().get_root().get_node("Main")
	var balls_container
	
	var new_ball = preload('res://Scenes/Objects/Ball.tscn').instance()
	
	if root.has_node(CONTAINER_NAME_BALLS):
		balls_container = root.get_node(CONTAINER_NAME_BALLS)
	else:
		balls_container = Node2D.new()
		root.add_child(balls_container)
		balls_container.set_name(CONTAINER_NAME_BALLS)
	
	balls_container.add_child(new_ball)
	new_ball.set_pos(vector_pos)
	new_ball.set_linear_velocity(vector_speed)
