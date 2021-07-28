extends Control

func _ready():
	self.visible = false
	
	
	
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		self.visible = !self.visible
	
	
