#@tool
extends Node2D

class_name Mask

var currentMask : MaskResource = preload("res://Data/Resources/Masks/EmptyMask.tres")

var currentWeaponTimer : float = 0.0
var canFireProjectile : bool = true
@export var projectile : PackedScene

@onready var mask_sprite: Sprite2D = %MaskSprite
@onready var shoot_point: Node2D = %ShootPoint

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	shoot_point.look_at(get_global_mouse_position())
	
	if currentWeaponTimer > 0.0:
		currentWeaponTimer -= delta
		if currentWeaponTimer <= 0.0:
			canFireProjectile = true
		
	if canFireProjectile == true:
		if Input.is_action_pressed("Shoot"):
			currentWeaponTimer = (1.0 / currentMask.projectileFireRate)
			canFireProjectile = false
			GameEvents.shot_fired.emit(shoot_point.global_position, get_global_mouse_position(), currentMask.projectileType)


func SetMask(maskRes : MaskResource):
	currentMask = maskRes
	_UpdateSwitchedMask()

func _UpdateSwitchedMask():
	mask_sprite.texture = currentMask.maskSprite
