extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -400.0

@export var max_hp := 10

@export var masks : Array[MaskResource] = []
var currentMaskIndex : int = -1

@onready var maskRef : Mask = $Mask
@onready var base_sprite: AnimatedSprite2D = $BaseSprite

var current_hp: int 

func _ready() -> void:
	current_hp = max_hp
	if not masks.is_empty():
		currentMaskIndex = 0
		_UpdateEquippedMask()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugMaskNext"):
		maskRef.OnSwitchNextMask()
	if event.is_action_pressed("MaskNext"):
		_MoveToNextMask()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("DebugMaskPrev"):
		maskRef.OnSwitchPrevMask()
	if event.is_action_pressed("MaskPrev"):
		_MoveToPrevMask()
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if direction:
		velocity = direction * SPEED
		base_sprite.play("run")
	else:
		base_sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		current_hp -= body.damage 
		print("Player HP: " + str(current_hp))
		if current_hp <= 0:
			print("You are died!")
			hide()
			
func _MoveToNextMask():
	if not masks.is_empty():
		currentMaskIndex = wrapi(currentMaskIndex + 1, 0, masks.size())
		_UpdateEquippedMask()

func _MoveToPrevMask():
	if not masks.is_empty():
		currentMaskIndex = wrapi(currentMaskIndex - 1, 0, masks.size())
		_UpdateEquippedMask()
	
func _UpdateEquippedMask():
	if currentMaskIndex >= 0 and not masks.is_empty():
		maskRef.SetMask(masks[currentMaskIndex])
