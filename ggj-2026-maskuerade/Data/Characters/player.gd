extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -400.0

@onready var maskRef : Mask = $Mask

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugMaskNext"):
		maskRef.OnSwitchNextMask()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("DebugMaskPrev"):
		maskRef.OnSwitchPrevMask()
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
