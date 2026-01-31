extends Node2D
class_name SpawnPoint

@export var CharacterToSpawn : Enemy_Resource
@export var SpawnCount : int = 1
@export var SpawnRate : float = 1.0
@onready var spawnLight : PointLight2D = $PointLight2D

var currentSpawnTimer : float = 0.0
var canSpawnEnemy : bool = true

var allowedToSpawn : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if CharacterToSpawn == null || SpawnCount <= 0:
		_UpdateSpawnPoint()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if allowedToSpawn == false || SpawnCount <= 0:
		return
	
	if currentSpawnTimer > 0.0:
		currentSpawnTimer -= delta
		if currentSpawnTimer <= 0.0:
			canSpawnEnemy = true
		
	if canSpawnEnemy == true:
		currentSpawnTimer = (1.0 / SpawnRate)
		canSpawnEnemy = false
		SpawnCount -= 1
		_UpdateSpawnPoint()
		GameEvents.enemy_spawn.emit(position, CharacterToSpawn)
		

func _UpdateSpawnPoint():
	if SpawnCount <= 0 :
		allowedToSpawn = false
		spawnLight.enabled = false
		self.hide()

func _on_timer_timeout() -> void:
	if CharacterToSpawn != null || SpawnCount > 0:
		allowedToSpawn = true
