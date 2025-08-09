extends Node2D

@export var basic_block: PackedScene

@export var ScoreLabel: Label

var score = 0
var score_multiplier = 1

const simple_block = preload("res://Ressources/Box_test.tscn")
const small_l_piece = preload("res://Ressources/Box_test.tscn")
const small_i_piece = preload("res://Ressources/Box_test.tscn")

var selected_block = null

var base_plate_position

var base_plate_collider
var base_plate_collision_position

func _ready() -> void:
	GlobalSignals.spawn_newblock.connect(spawn_new_block)

func _on_block_timer_timeout() -> void:
	spawn_new_block()

func spawn_new_block():
	print("Spawning new Block")
	var b = simple_block.instantiate()
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
