extends Node2D
class_name Projectile

@export var speed := 5.0
@export var dir: Vector2 = Vector2(-1,0)
@export var damage: = 2.0

#func _physics_process(_delta: float) -> void:
	#position += dir * speed 


#func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
