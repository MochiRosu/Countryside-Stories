class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.RIGHT
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 100
var state : String = "idle"

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	pass

func _process(delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = direction * move_speed

	if SetState() or SetDirection():
		UpdateAnimation()

func _physics_process(delta):
	move_and_slide()

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	
	if direction == Vector2.ZERO:
		return false
	
	if direction.x != 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.y != 0:
		# Keep the current facing direction when moving vertically
		new_dir = cardinal_direction
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	return true

func SetState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	
	if new_state == state:
		return false
	
	state = new_state
	return true

func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.LEFT:
		return "left"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	# Default case, return right if no other direction matches
	return "right"
