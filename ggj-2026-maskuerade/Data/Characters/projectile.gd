extends Area2D
class_name Projectile



@export var speed := 5.0
@export var dir: Vector2 = Vector2(-1,0)
@export var damage: = 2.0

var mask_type = "default"
var previous_position: Vector2
@onready var sprite = $Sprite2D
@onready var light = %PointLight2D

func _ready():
	previous_position = global_position
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	var collision = _get_collision(body)
	if collision:
		handle_collision(body, collision.position, collision.normal)
	else:
		handle_collision(body, global_position, Vector2.ZERO)

func _get_collision(body: Node):
	var space_state = get_world_2d().direct_space_state
	
	var movement = global_position - previous_position
	var movement_length = movement.length()
	
	if movement_length < 0.1:
		movement = dir.normalized() * 10.0
		movement_length = 10.0
	
	#huge rays to report SOMETHING
	var ray_multiplier = 10
	var ray_end = previous_position + movement.normalized() * (movement_length * ray_multiplier)
	
	var query = PhysicsRayQueryParameters2D.create(previous_position, ray_end)
	query.collide_with_areas = true
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result and result.collider == body:
		return {
			"position": result.position,
			"normal": result.normal
		}
	return {}

func handle_collision(body: Node, collision_point: Vector2, collision_normal: Vector2):
	if body.is_in_group("player"):
		pass
	elif body.is_in_group("enemy"):
		GameEvents.enemy_hit.emit(self, body as Enemy)
	elif body is TileMapLayer:
		GameEvents.wall_hit.emit(self, collision_point, collision_normal)
	else:
		print("hit something unhandled: ", body)

func _on_area_entered(area: Node):
	_on_body_entered(area)

func update_previous_position():
	previous_position = global_position


func set_projectile_color(color: Color) -> void:
	sprite.modulate = color
	light.color = color
