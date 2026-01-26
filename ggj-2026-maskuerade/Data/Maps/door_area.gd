extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.emit_signal("room_exited")
		queue_free()
