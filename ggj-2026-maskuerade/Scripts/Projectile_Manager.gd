extends Node

@onready var parent_scene := get_parent()
@export var projectile_scene : PackedScene = preload("res://Data/Characters/projectile.tscn")

#Dictionary: int -> Array[Projectile]
var projectiles = Dictionary()

func _ready():
	GameEvents.shot_fired.connect(_on_shot_fired)

func _on_shot_fired(shoot_point, mouse_position, mask_type):
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
	var shot_type = projectiles.get_or_add(mask_type, [])
	shot_type.append(inst)
	#print(projectiles)

func _physics_process(_delta: float) -> void:
	for key in projectiles:
		for projectile in projectiles[key]:
			projectile.global_position += projectile.dir * projectile.speed

func _projectile_offscreen(projectile):
	var mask_type = projectile.mask_type
	var type = projectiles.get(mask_type)
	type.erase(projectile)
	projectile.queue_free.call_deferred()
