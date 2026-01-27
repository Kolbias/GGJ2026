extends CharacterBody2D
class_name Enemy

#Enemy Stats
@export var max_hp := 10
@export var damage := 2
@export var speed := 5.0

@onready var state_debug_label: Label = %StateDebugLabel
@onready var hp_bar: ProgressBar = %HPBar

#State Machine Setup
enum State {IDLE, WANDER, CHASE}
var current_state = State.IDLE

var player_pos: Vector2
var dir: Vector2
var current_hp: int

func _ready() -> void:
	hp_bar.max_value = max_hp
	current_hp = max_hp


func _process(_delta: float) -> void:
	hp_bar.value = current_hp
	#State machine logic
	match current_state:
		State.IDLE:
			state_debug_label.text = "IDLE"
			
		State.WANDER:
			state_debug_label.text = "WANDER"
			
		State.CHASE:
			state_debug_label.text = "CHASE"
			dir = player_pos - global_position
			
			
	velocity = dir * speed
	move_and_slide()
	
func change_state(new_state):
	current_state = new_state

func _on_timer_timeout() -> void:
	var rand_dir = [-1.0, 1.0, 0.0]
	dir = Vector2(rand_dir.pick_random(), rand_dir.pick_random())
	change_state(State.WANDER)

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_pos = body.position
		change_state(State.CHASE)

func _on_hitbox_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		current_hp -= area.damage
		if current_hp <= 0:
			queue_free()
			GameEvents.emit_signal("enemy_killed")
			
		#area.queue_free()
