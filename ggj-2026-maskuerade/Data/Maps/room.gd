extends Node2D
class_name Room

@export var entrance_pos: Node2D
@export var doors_node: Node2D
@export var spawners_node: Node2D

var enemies_on_floor : bool = false
var enemy_count: int = 0
var next_room : PackedScene

func _ready() -> void:
	GameEvents.connect("room_sent", _on_room_sent)
	GameEvents.connect("enemy_killed", _on_enemy_killed)
	if spawners_node != null && spawners_node.get_child_count() > 0:
		for spawner : SpawnPoint in spawners_node.get_children():
			enemy_count += spawner.SpawnCount
			spawner.allowedToSpawn = true
	
	print("Enemy Count: " + str(enemy_count))
	if enemy_count > 0:
		enemies_on_floor = true
	for i in doors_node.get_children():
		GameEvents.emit_signal("room_requested")
		
# Returns the position of the EnterPos (used to move player on room entry)
func get_entrance_pos() -> Vector2:
	return entrance_pos.global_position

# Looks for the first Door Scene without a 'Next Room' @export 
# and sets the sent Room as the Next Room on it
func _on_room_sent(room : PackedScene):
	for d in doors_node.get_children():
		if d.is_in_group("door"):
			if d.next_room == null:
				d.next_room = room
				return
			else:
				print("room filled")
				continue
	print("Rooms Recieved: " + str(next_room))
	
	
func _on_enemy_killed():
	enemy_count -= 1
	print("Enemy Count: " + str(enemy_count))
	if enemy_count <= 0:
		GameEvents.emit_signal("enemies_cleared")
		GameEvents.rooms_cleared += 1
		print("Rooms Cleared: " + str(GameEvents.rooms_cleared))
