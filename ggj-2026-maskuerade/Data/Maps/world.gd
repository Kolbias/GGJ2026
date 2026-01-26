extends Node2D

@export var rooms : Array[PackedScene]

@onready var player: CharacterBody2D = %Player
@onready var current_room: Node2D = %CurrentRoom

func _ready() -> void:
	GameEvents.connect("room_exited", _on_room_exited)
	
func _on_room_exited():
	var inst = rooms.pick_random().instantiate()
	for i in current_room.get_children():
		i.queue_free()
	current_room.call_deferred("add_child", inst)
	player.global_position = inst.get_entrance_pos()
	
	
	
