extends Node2D

@export var entrance_pos: Node2D

func get_entrance_pos() -> Vector2:
	return entrance_pos.global_position
