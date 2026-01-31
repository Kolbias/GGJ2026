extends Area2D
class_name Door

@export var next_room: PackedScene
@onready var poof_particle: CPUParticles2D = %PoofParticle

func _ready() -> void:
	GameEvents.connect("enemies_cleared", _on_enemies_cleared)
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.emit_signal("room_exited", next_room)
		queue_free()

func _on_enemies_cleared():
	poof_particle.emitting = true
	show()
	
	# Give some grace time before allowing player to enter the next room
	await get_tree().create_timer(2.5).timeout
	monitoring = true

func set_room(new_room: PackedScene):
	next_room = new_room
