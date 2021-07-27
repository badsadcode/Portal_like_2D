extends Node2D


onready var body_torso = $"Torso"
onready var body_head = $"Head"
onready var body_legs = $"Legs"
onready var body_arms = $"Arms"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_animations("run")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func play_animations(aAnimation: String):

	body_head.play(aAnimation)
	body_arms.play(aAnimation)
	body_torso.play(aAnimation)
	body_legs.play(aAnimation)
