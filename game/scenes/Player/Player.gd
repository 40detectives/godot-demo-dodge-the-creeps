extends Area2D

# NOTE: "export" keyword exposes the var to be set in the Inspector
export var speed = 400 # How fast the player will move (pixels/seconds)
var screen_size # Size of the game window
signal hit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start(pos):
	position = pos
	show()
	get_node("CollisionShape2D").disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# var to store player displacement rate:
	var velocity = Vector2() # The player's movement vector. Right now is: (0,0)
	
	# Check player input:
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# Normalize the magnitude of the vector so diagonal speed is the same as v/h movement:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		get_node("AnimatedSprite").play()
	else:
		get_node("AnimatedSprite").stop()
	
	# This avoids going out of viewport:
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Sprite animation flips:
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Player disappears afeter being hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
