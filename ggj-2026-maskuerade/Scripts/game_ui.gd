extends Control

@export var player: CharacterBody2D

@onready var hp_bar: TextureProgressBar = %HPBar
@onready var game_ui: Control = %GameUI
@onready var floor_num_label: Label = %FloorNumLabel
@onready var mask_texture: TextureRect = %MaskTexture
@onready var label_mask_type: Label = %LabelMaskType
@onready var game_over_menu: Control = %GameOverMenu

func _ready() -> void:
	GameEvents.connect("mask_changed", _on_mask_changed)
	GameEvents.connect("player_died", _on_player_died)

func _process(_delta: float) -> void:
	if player:
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.current_hp
	floor_num_label.text = str(GameEvents.rooms_cleared)
	
func _on_play_button_pressed() -> void:
	game_ui.show()

func _on_mask_changed(mask: MaskResource) -> void:
	mask_texture.texture = mask.maskSprite
	label_mask_type.text = mask.maskName

func _on_player_died():
	game_over_menu.show()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
