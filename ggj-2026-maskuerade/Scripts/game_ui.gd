extends Control

@export var player: CharacterBody2D

@onready var hp_bar: TextureProgressBar = $MarginContainer/HBoxContainer/HPBar

func _process(_delta: float) -> void:
	if player:
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.current_hp
