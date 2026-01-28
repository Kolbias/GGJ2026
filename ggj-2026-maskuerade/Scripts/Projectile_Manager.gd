extends Node

@onready var parent_scene := get_parent()
@export var projectile_scene : PackedScene = preload("res://Data/Characters/projectile.tscn")
#Dictionary: int -> Array[Projectile]
var projectiles = Dictionary()
var cull = false

var projectile_defs = {
	"default": {
		speed = 5.0,
		damage = 2,
		max_count = 20
	},
	"bounce": {
		speed = 3.0,
		damage = 1,
		max_count = 3
	}
}

func _ready():
	GameEvents.shot_fired.connect(_on_shot_fired)
	GameEvents.enemy_hit.connect(_on_enemy_hit)
	GameEvents.wall_hit.connect(_on_wall_hit)
	GameEvents.room_exited.connect(_remove_all)

func _on_shot_fired(shoot_point, mouse_position, mask_type):
	var shot_type = projectiles.get_or_add(mask_type, [])
	print(shot_type.size())
	if not shot_type.size() < projectile_defs[mask_type].max_count:
		return
	#Instantiate and set properties
	var inst = projectile_scene.instantiate()
	inst.position = shoot_point
	inst.dir = (mouse_position - shoot_point).normalized()
	inst.mask_type = mask_type
	#Set up signal listeners
	var visibility_notifier = inst.get_node("VisibleOnScreenNotifier2D")
	visibility_notifier.screen_exited.connect(_projectile_offscreen.bind(inst))
	#Add to scene at end of current frame
	parent_scene.add_child.call_deferred(inst)
	#Append to dictionary
	
	shot_type.append(inst)
	#print(projectiles)

func _physics_process(_delta: float) -> void:
	var to_remove = []
	for key in projectiles:
		for projectile in projectiles[key]:
			if not cull:
				projectile.global_position += projectile.dir * projectile.speed
				if projectile.position == projectile.previous_position:
					to_remove.append(projectile)
				else:
					projectile.update_previous_position()
			else:
				to_remove.append(projectile)
	for projectile in to_remove:
		_safe_remove(projectile)
	if cull:
		cull = false

func _safe_remove(projectile):
	var mask_type = projectile.mask_type
	var type = projectiles.get(mask_type)
	type.erase(projectile)
	projectile.queue_free.call_deferred()

func _projectile_offscreen(projectile):
	_safe_remove(projectile)

func _on_enemy_hit(projectile: Projectile, enemy: Enemy):
	print(projectile, " hit ", enemy)
	_safe_remove(projectile)

func _on_wall_hit(projectile: Projectile, position: Vector2, normal: Vector2):
	var mask_type = projectile.mask_type
	match mask_type:
		"default":
			_safe_remove(projectile)
		"bounce":
			print("bounce at ", position)
			projectile.dir = projectile.dir.bounce(normal)

func _remove_all():
	cull = true
	#for key in projectiles:
		#for projectile in projectiles[key]:
			#_safe_remove(projectile)
