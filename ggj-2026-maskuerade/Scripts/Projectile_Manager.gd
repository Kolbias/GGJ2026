extends Node

@onready var parent_scene := get_parent()
@export var projectile_scene : PackedScene = preload("res://Data/Characters/projectile.tscn")

var projectiles: Array[Projectile] = []

func _ready():
	GameEvents.shot_fired.connect(_on_shot_fired)

func _on_shot_fired(shoot_point, mouse_position):
	#Instantiate and set properties
	var inst = projectile_scene.instantiate()
	inst.position = shoot_point
	inst.dir = (mouse_position - shoot_point).normalized()
	#Set up signal listeners
	var visibility_notifier = inst.get_node("VisibleOnScreenNotifier2D")
	visibility_notifier.screen_exited.connect(_projectile_offscreen.bind(inst))
	#Add at end of current frame
	parent_scene.add_child.call_deferred(inst)
	projectiles.append(inst)

func _physics_process(_delta: float) -> void:
	for projectile in projectiles:
		projectile.global_position += projectile.dir * projectile.speed

func _projectile_offscreen(projectile):
	projectile.queue_free.call_deferred()
	projectiles.erase(projectile)
