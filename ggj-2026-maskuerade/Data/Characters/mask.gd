@tool
extends Node2D

@export var mask_index : int = 0
@export var projectile : PackedScene

@onready var mask_sprite: Sprite2D = %MaskSprite
@onready var shoot_point: Node2D = %ShootPoint

func _ready() -> void:
	mask_sprite.frame = mask_index

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
