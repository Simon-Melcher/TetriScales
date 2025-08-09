extends Node2D

func _ready() -> void:
	$CanvasLayer/AnimatedSprite2D.play()
	
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 2
	timer.timeout.connect(_on_timer_usage_timeout)
	timer.start()
	
func _on_timer_usage_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main-Game.tscn")
