extends Node2D

@export var entrance_pos: Node2D

@onready var enemies: Node2D = %Enemies

var enemies_on_floor : bool = false
var enemy_count: int

func _ready() -> void:
	GameEvents.connect("enemy_killed", _on_enemy_killed)
	enemy_count = enemies.get_child_count()
	print("Enemy Count: " + str(enemy_count))
	if enemy_count > 0:
		enemies_on_floor = true

# Returns the position of the EnterPos (used to move player on room entry)
func get_entrance_pos() -> Vector2:
	return entrance_pos.global_position

func _on_enemy_killed():
	enemy_count = enemies.get_child_count() - 1
	print("Enemy Count: " + str(enemy_count))
	if enemy_count <= 0:
		GameEvents.emit_signal("enemies_cleared")
	
