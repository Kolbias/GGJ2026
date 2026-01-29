class_name Attack
extends Node

var attack_damage: float
var knockback_force: float
var attack_origin: Vector2

func _init(damage, force, origin):
		attack_damage = damage
		knockback_force = force
		attack_origin = origin
