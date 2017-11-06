extends Label

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	self.text = 'FPS: ' + str(OS.get_frames_per_second())