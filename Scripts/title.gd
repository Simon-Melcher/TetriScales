extends Node2D

func _ready() -> void:
	pass
	

func _on_timer_autostart_placeholder_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/usage.tscn")
