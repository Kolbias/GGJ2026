@tool
extends Node2D

class_name Mask

@export var mask_index : int = 0
@export var max_mask_index : int = 0
@export var projectile : PackedScene

@onready var mask_sprite: Sprite2D = %MaskSprite
@onready var shoot_point: Node2D = %ShootPoint
var mask_types = []

func _ready() -> void:
	_UpdateSwitchedMask()
	#temporary to set mask_types array
	mask_types.resize(max_mask_index + 1)
	mask_types.fill("default")
	mask_types[1] = "bounce"

func _process(_delta: float) -> void:
	shoot_point.look_at(get_global_mouse_position())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		GameEvents.shot_fired.emit(shoot_point.global_position, get_global_mouse_position(), mask_types[mask_index])

func OnSwitchNextMask():
	mask_index = wrapi(mask_index + 1, 0, max_mask_index - 1)
	_UpdateSwitchedMask()

func OnSwitchPrevMask():
	mask_sprite.frame
	mask_index = wrapi(mask_index - 1, 0, max_mask_index - 1)
	_UpdateSwitchedMask()

func _UpdateSwitchedMask():
	mask_sprite.frame = mask_index
