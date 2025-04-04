extends Node

@onready var level_container = $LevelContainer
@onready var ui = $UI 
var current_level
@onready var player = preload("res://player.tscn").instantiate()

func _ready():
	if ui.has_signal("start"):
		ui.connect("start", _on_start)  # Connect UI start signal

func load_level(level_scene: PackedScene):
	if current_level:
		current_level.queue_free()  # Remove the old level

	var level = level_scene.instantiate()  # Directly instantiate the PackedScene
	level_container.add_child(level)
	current_level = level

	# Position player at the new spawn point
	var player_spawn = level.find_child("PlayerSpawn", true, false)
	if player_spawn:
		player.global_position = player_spawn.global_position

	# Connect the level_complete signal if it exists
	if level.has_signal("level_complete"):
		level.connect("level_complete", _on_level_complete)

func _on_start():
	ui.hide()
	add_child(player)
	load_level(preload("res://level_1.tscn"))  # Directly pass the PackedScene

func _on_level_complete():
	if "next_level" in current_level and current_level.next_level:
		call_deferred("load_level", current_level.next_level)  # Safe execution
