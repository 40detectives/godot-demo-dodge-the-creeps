extends RigidBody2D

# Mob vars:
export var min_speed = 150
export var max_speed = 250
var mob_types = ["walk", "swim", "fly"]


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite").animation = mob_types[randi() % mob_types.size()]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
