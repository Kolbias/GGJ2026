extends Node2D

@export var entrance_pos: Node2D

# Returns the position of the EnterPos (used to move player on room entry)
func get_entrance_pos() -> Vector2:
	return entrance_pos.global_position
