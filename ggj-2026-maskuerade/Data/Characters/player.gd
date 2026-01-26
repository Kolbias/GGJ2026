extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -400.0

@export var max_hp := 10

@onready var maskRef : Mask = $Mask
@onready var anim: AnimationPlayer = %AnimationPlayer

var current_hp: int 

func _ready() -> void:
	current_hp = max_hp

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
		anim.play("run")
	else:
		anim.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		current_hp -= body.damage 
		print("Player HP: " + str(current_hp))
		if current_hp <= 0:
			print("You are died!")
			queue_free()
