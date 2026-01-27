#@tool
extends Node2D

class_name Mask

var currentMask : MaskResource = preload("res://Data/Resources/Masks/EmptyMask.tres")

@export var projectile : PackedScene

@onready var mask_sprite: Sprite2D = %MaskSprite
@onready var shoot_point: Node2D = %ShootPoint

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	shoot_point.look_at(get_global_mouse_position())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		GameEvents.shot_fired.emit(shoot_point.global_position, get_global_mouse_position(), currentMask.maskType)

func SetMask(maskRes : MaskResource):
	currentMask = maskRes
	_UpdateSwitchedMask()

func _UpdateSwitchedMask():
	mask_sprite.texture = currentMask.maskSprite
