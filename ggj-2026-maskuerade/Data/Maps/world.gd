extends Node2D

@export var rooms_level_1 : Array[PackedScene]
@export var rooms_level_2 : Array[PackedScene]
@export var rooms_level_3 : Array[PackedScene]
@export var level_2_threshold: int = 1
@export var level_3_threshold: int = 2

@export var player_scene: PackedScene

@onready var player: Player 
@onready var current_room: Node2D = %CurrentRoom
@onready var game_ui: Control = %GameUI
@onready var main_menu: Control = %MainMenu
@onready var transition: ColorRect = %Transition

func _ready() -> void:
	GameEvents.connect("room_exited", _on_room_exited)
	GameEvents.connect("room_requested", _on_room_requested)
	
func _on_room_exited(new_room: PackedScene):
	player.LockPlayer()
	# Tween the room transition node's color
	var t = create_tween()
	t.tween_property(transition, "modulate", Color(), 0.1)
	t.tween_interval(0.5)
	await t.finished
	var t2 = create_tween()
	t2.tween_property(transition, "modulate", Color(0, 0, 0, 0), 0.2)
	for i in current_room.get_children():
		i.queue_free()
		
	# Spawns room from PackedScene sent thru signal from Door scene
	var inst = new_room
	inst = new_room.instantiate()
	current_room.call_deferred("add_child", inst)
	
	player.UnlockPlayer()
	
	# Old line to put player in spawn location
	#player.global_position = inst.get_entrance_pos()
	
func _on_play_button_pressed() -> void:
	# Adds the player scene and links it to nodes that need access to it
	var inst = player_scene.instantiate()
	add_child(inst)
	player = inst
	game_ui.player = inst
	inst.position = Vector2(128,128)
	main_menu.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Listen for Room to ask for New Rooms to link to Doors
func _on_room_requested():
	var room_count = GameEvents.rooms_cleared
	if room_count < (level_2_threshold - 1):
		var new_room = rooms_level_1.pick_random()
		GameEvents.emit_signal("room_sent", new_room)
		
	elif room_count >= (level_2_threshold - 1) and room_count <= (level_3_threshold -1):
		var new_room = rooms_level_2.pick_random()
		GameEvents.emit_signal("room_sent", new_room)

	elif room_count >= level_3_threshold:
		var new_room = rooms_level_3.pick_random()
		GameEvents.emit_signal("room_sent", new_room)
		

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
