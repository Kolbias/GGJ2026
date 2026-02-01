extends Node

#signal shot_fired(shoot_position: Vector2, mouse_pos: Vector2)
signal room_requested
signal room_sent(PackedScene)
signal room_exited(PackedScene)

signal mask_changed(MaskResource)
signal player_died

signal shot_fired(shoot_position: Vector2, mouse_pos: Vector2, mask_index: String)
signal enemy_shot_fired(projectile: Projectile, enemy: Enemy)
signal player_hit(projectile: Projectile, player_instance: Player)
signal enemy_hit(projectile: Projectile, enemy: Enemy)
signal wall_hit(projectile: Projectile, position: Vector2, normal: Vector2)

signal enemy_death(enemyRef : Enemy)
signal enemy_killed
signal enemies_cleared

var rooms_cleared := 0

signal enemy_spawn(spawnPosition: Vector2, enemyResource : Enemy_Resource)
signal clear_enemies()
