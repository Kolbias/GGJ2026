extends CharacterBody2D
class_name Player

enum PlayerState {Default, Locked, Dead, Boosting}


const MAXSPEED : float = 85.0
var currentSpeed : float = 0.0
var lastDirection : Vector2
var currentState : PlayerState = PlayerState.Default

var stateAtLock : PlayerState = PlayerState.Default

@export var max_hp := 10

@export var masks : Array[MaskResource] = []
var currentMaskIndex : int = -1

@onready var afterImageSys : GPUParticles2D = $BaseSprite/AfterImage

@onready var maskRef : Mask = $Mask
@onready var base_sprite: AnimatedSprite2D = $BaseSprite

var current_hp: int 

func _ready() -> void:
	current_hp = max_hp
	if not masks.is_empty():
		currentMaskIndex = 0
		_UpdateEquippedMask()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MaskNext"):
		_MoveToNextMask()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("MaskPrev"):
		_MoveToPrevMask()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("UseAbility"):
		_UseAbility()
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	match currentState:
		PlayerState.Default:
			_UpdateDefaultMovement(direction)
		PlayerState.Locked:
			velocity = Vector2(0,0)
		PlayerState.Dead:
			return
		PlayerState.Boosting:
			_UpdateBoostingMovement(direction)
				
	move_and_slide()


func _on_hurtbox_body_entered(body: Enemy) -> void:
	if body.is_in_group("enemy") and not currentState == PlayerState.Boosting:
		current_hp -= body.enemy_Resource.damage 
		print("Player HP: " + str(current_hp))
		if current_hp <= 0:
			print("You are died!")
			currentState = PlayerState.Dead
			GameEvents.emit_signal("player_died")
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

func _UseAbility():
	currentState = PlayerState.Boosting
	afterImageSys.emitting = true
	currentSpeed = 350
	
func _UpdateDefaultMovement(direction : Vector2):
	if direction:
		lastDirection = direction
		currentSpeed = MAXSPEED
		velocity = lastDirection * currentSpeed
		base_sprite.play("run")
	else:
		base_sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, MAXSPEED)
		velocity.y = move_toward(velocity.y, 0, MAXSPEED)

func _UpdateBoostingMovement(direction : Vector2):
	currentSpeed = move_toward(currentSpeed, MAXSPEED, 10)
	if direction:
		lastDirection = direction
	velocity = lastDirection * currentSpeed
	base_sprite.play("run")
	if currentSpeed <= MAXSPEED:
		afterImageSys.emitting = false
		currentState = PlayerState.Default

func LockPlayer():
	stateAtLock = currentState
	currentState = PlayerState.Locked

func UnlockPlayer():
	currentState = stateAtLock
