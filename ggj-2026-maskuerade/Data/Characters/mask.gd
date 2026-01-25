@tool
extends Node2D

class_name Mask

@export var mask_index : int = 0
@export var max_mask_index : int = 0
@export var projectile : PackedScene

@onready var mask_sprite: Sprite2D = %MaskSprite
@onready var shoot_point: Node2D = %ShootPoint

func _ready() -> void:
	_UpdateSwitchedMask()

func _process(_delta: float) -> void:
	shoot_point.look_at(get_global_mouse_position())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		var inst = projectile.instantiate()
		
		inst.dir = get_global_mouse_position() - shoot_point.global_position
		inst.dir = inst.dir.normalized()
		
		# 🤚 Don't do this at home kids! ...consider replacing with Global Signal/Autoload
		get_parent().get_parent().add_child(inst)
		
		inst.global_position = shoot_point.global_position
		inst.global_rotation = shoot_point.global_rotation

func OnSwitchNextMask():
	mask_index = wrapi(mask_index + 1, 0, max_mask_index - 1)
	_UpdateSwitchedMask()

func OnSwitchPrevMask():
	mask_sprite.frame
	mask_index = wrapi(mask_index - 1, 0, max_mask_index - 1)
	_UpdateSwitchedMask()

func _UpdateSwitchedMask():
	mask_sprite.frame = mask_index
