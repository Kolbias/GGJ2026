extends Node2D

@export var rooms : Array[PackedScene]
@export var player_scene: PackedScene

@onready var player: Player 
@onready var current_room: Node2D = %CurrentRoom
@onready var game_ui: Control = %GameUI
@onready var main_menu: Control = %MainMenu
@onready var transition: ColorRect = %Transition

func _ready() -> void:
	GameEvents.connect("room_exited", _on_room_exited)
	
	
func _on_room_exited():
	player.LockPlayer()
	# Tween the room transition node's color
	var t = create_tween()
	t.tween_property(transition, "modulate", Color(), 0.1)
	t.tween_interval(0.5)
	await t.finished
	var t2 = create_tween()
	t2.tween_property(transition, "modulate", Color(0, 0, 0, 0), 0.2)
	
	# Picks a random room deletes the previous one and spawns in the new on
	var inst = rooms.pick_random().instantiate()
	for i in current_room.get_children():
		i.queue_free()
	current_room.call_deferred("add_child", inst)
	player.UnlockPlayer()
	# Old line to pull player spawn location
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
