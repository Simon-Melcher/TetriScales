extends Node2D

@export var basic_block: PackedScene

var score

const simple_block = preload("res://Ressources/Box_test.tscn")
const small_l_piece = preload("res://Ressources/Box_test.tscn")

var selected_block

func _ready() -> void:
	var screen_size = get_tree().root.get_viewport().size
	print("screen_size", screen_size)

	var block_timer = Timer.new()
	add_child(block_timer)
	block_timer.wait_time = 5
	block_timer.start()
	block_timer.timeout.connect(_on_block_timer_timeout)

	_on_block_timer_timeout()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	#pass

func _on_block_timer_timeout() -> void:
	var b = simple_block.instantiate()
	selected_block = b
	add_child(b)

func _physics_process(delta):
	if(selected_block != null):
		if Input.is_action_pressed("move_left"):
			selected_block.apply_force(Vector2(-100,0)) 
		if Input.is_action_pressed("move_right"):
			selected_block.apply_force(Vector2(100,0)) 
		if Input.is_action_pressed("rotate_block"):
			selected_block.apply_torque_impulse(50)
			
