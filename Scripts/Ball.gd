extends RigidBody2D

export (int) var SPEED_UP = 1.1
export (int) var MAX_SPEED = 300

onready var level = get_node('/root/Main')
onready var sound = get_node('/root/Main/Sound')

var c_count_array = [4, 12]
var c_counter = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()

	for body in bodies:
		if body.get_parent().get_name() == Levels.CONTAINER_NAME_BRICKS:
			c_counter += 1
			if c_counter in c_count_array:
				print('Increase speed')
				var speed_up = get_linear_velocity()
				set_linear_velocity(speed_up * SPEED_UP)
				if c_counter > 11:
					c_counter = 0
			collide_brick(body)
		if body.get_name() == 'Paddle':
			pass

func collide_brick(brick):
	brick.hardness -= 1

	if brick.hardness <= 0:
		level.score = 5 * brick.score_multiplier
		sound.play(brick.snd_destroy)
		brick.queue_free()
	else:
		brick.set_opacity(brick.get_opacity() - brick.opacity_dec)
		sound.play(brick.snd_collide)