extends Control

@export var player: CharacterBody2D

@onready var hp_bar: TextureProgressBar = $MarginContainer/HBoxContainer/HPBar
@onready var game_ui: Control = %GameUI

func _process(_delta: float) -> void:
	if player:
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.current_hp

func _on_play_button_pressed() -> void:
	game_ui.show()
