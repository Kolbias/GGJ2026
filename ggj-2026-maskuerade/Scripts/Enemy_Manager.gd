extends Node
class_name Enemy_Manager

@onready var parent_scene := get_parent()
@export var enemy_scene : PackedScene = preload("res://Data/Characters/enemy.tscn")

var enemies : Array[Enemy]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.enemy_spawn.connect(_on_enemy_spawn)
	GameEvents.clear_enemies.connect(_on_clear_enemies)
	GameEvents.enemy_death.connect(_on_enemy_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_enemy_spawn(spawnPosition: Vector2, enemyResource : Enemy_Resource):	
	#Instantiate and set properties
	var enemyInst : Enemy = enemy_scene.instantiate()
	enemyInst.position = spawnPosition
	enemyInst.enemy_Resource = enemyResource
	parent_scene.add_child.call_deferred(enemyInst)
	enemies.append(enemyInst)

func _on_enemy_death(enemyRef : Enemy):
	enemies.erase(enemyRef)
	enemyRef.queue_free()
	GameEvents.emit_signal("enemy_killed")
			

func _on_clear_enemies():
	for enemy : Enemy in enemies: 
		enemy.queue_free()
	enemies.clear()
