extends Node2D

@export var basic_block: PackedScene

@export var ScoreLabel: Label

var score = 0
var score_multiplier = 1

const simple_block = preload("res://Ressources/Box_test.tscn")
const small_l_piece = preload("res://Ressources/Box_test.tscn")
const small_i_piece = preload("res://Ressources/Box_test.tscn")

const Block_1x1 = preload("res://Scenes/block_1x1.tscn")
const Block_2x2_L = preload("res://Scenes/block_2x2_l.tscn")
const Block_3x1 = preload("res://Scenes/block_3x1.tscn")

var selected_block = null

func _ready() -> void:
	var screen_size = get_tree().root.get_viewport().size
	print("screen_size", screen_size)

	GlobalSignals.spawn_newblock.connect(spawn_new_block)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	#pass

func _on_block_timer_timeout() -> void:
	spawn_new_block()

func instantiate_random_block() -> RigidBody2D:
	# Pick a random Block scene
	const blocks = [Block_1x1, Block_2x2_L, Block_3x1]
	var block = blocks.pick_random()
	var b = block.instantiate()
	return b
	
func spawn_new_block():
	print("Spawning new Block")
	#var b = simple_block.instantiate()
	var b = instantiate_random_block()
	#b.position = event.position
	#b.position = Vector2(randf_range(0, screen_size.x), 0)
	#b.linear_velocity = Vector2.DOWN * 50
	#add_child(b)
	b.position = Vector2(0,-200)
	selected_block = b
	add_child(b)

func _physics_process(delta):
	if(selected_block != null):
		if Input.is_action_pressed("move_left"):
			selected_block.apply_impulse(Vector2(-10,0)) 
		if Input.is_action_pressed("move_right"):
			selected_block.apply_impulse(Vector2(10,0)) 
		if Input.is_action_pressed("rotate_block"):
			selected_block.apply_torque_impulse(50)
		if Input.is_action_pressed("move_down"):
			selected_block.apply_impulse(Vector2(0,+10)) 
			score_multiplier += 0.01
		if Input.is_action_just_released("move_down"):
			selected_block.linear_velocity.y = 0 
		if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
			selected_block.linear_velocity.x = 0 
	else:
		spawn_new_block()

func increase_score_multiplier(amount: float):
	score_multiplier += amount

func increase_score():
	score += 1 * score_multiplier
	ScoreLabel.text = "Score: %s" % score

var time_out = 1
var time = time_out

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
	else:
		time = time_out
		increase_score()
