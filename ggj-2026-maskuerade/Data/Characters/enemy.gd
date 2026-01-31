extends CharacterBody2D
class_name Enemy

#Enemy Stats
@export var enemy_Resource : Enemy_Resource

@onready var state_debug_label: Label = %StateDebugLabel
@onready var hp_bar: ProgressBar = %HPBar
@onready var animSys : AnimatedSprite2D = %AnimatedSprite2D
@onready var hitboxArea : Area2D = $HitboxArea
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
#State Machine Setup
enum State {IDLE, WANDER, CHASE, DEAD}
var current_state = State.IDLE

var player_pos: Vector2
var dir: Vector2
var current_hp: int

func _ready() -> void:
	hp_bar.max_value = enemy_Resource.max_hp
	current_hp = enemy_Resource.max_hp
	animSys.sprite_frames = enemy_Resource.Visuals
	animSys.play("default")
	var rand_dir = [-1.0, 1.0, 0.0]
	dir = Vector2(rand_dir.pick_random(), rand_dir.pick_random())
	change_state(State.WANDER)


func _process(_delta: float) -> void:
	if current_state == State.DEAD:
		return
	
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
			
			
	velocity = dir * enemy_Resource.speed
	move_and_slide()
	
func change_state(new_state):
	current_state = new_state

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_pos = body.position
		change_state(State.CHASE)

func take_damage(attack: Attack):
	current_hp -= attack.attack_damage
	if current_hp <= 0:
		_Kill()

func _Kill():
	change_state(State.DEAD)
	hp_bar.hide()
	#animSys.play("death")
	hitboxArea.monitoring = false
	collisionShape.set_deferred("disabled", false)
	GameEvents.enemy_death.emit(self)
