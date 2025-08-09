extends Node2D

@export var basic_block: PackedScene
@export var ScoreLabel: Label
@export var LostBlockLabel: Label
@export var game_over_label: Label
@export var high_score_label: Label

@export var exit_button: Button
@export var restart_button: Button

var base_speed = 300

var score = 0
var score_multiplier = 1

var lost_blocks = 0
var game_over_amount = 5
var game_over = false

const Block_1x1 = preload("res://Scenes/block_1x1.tscn")
const Block_2x2_L = preload("res://Scenes/block_2x2_l.tscn")
const Block_3x1 = preload("res://Scenes/block_3x1.tscn")
const IcyBlock_1x1 = preload("res://Scenes/icy_block_1x1.tscn")

var selected_block = null
var next_block = null

func _ready() -> void:
	GlobalSignals.spawn_newblock.connect(spawn_new_block)
	GlobalSignals.lost_block.connect(increase_lost_block_counter)
	game_over_label.visible = false
	high_score_label.visible = false
	exit_button.visible = false
	restart_button.visible = false
	exit_button.pressed.connect(close_game)
	restart_button.pressed.connect(restart_scene)
	var n = instantiate_random_block()
	set_next_block(n)

func restart_scene():
	get_tree().reload_current_scene()

func close_game():
	get_tree().quit()

func instantiate_random_block() -> RigidBody2D:
	# Pick a random Block scene
	const blocks = [Block_1x1, Block_2x2_L, Block_3x1, Block_1x1, Block_2x2_L, Block_3x1, IcyBlock_1x1]
	#const blocks = [Block_1x1, IcyBlock_1x1]
	
	var block = blocks.pick_random()
	
	var b = block.instantiate()
	b.rotation = deg_to_rad(90*randi_range(0,4))
	return b

func set_next_block(b):
	next_block = b
	if not b:
		return
		
	$PreviewSubViewportContainer.set_next(next_block)
	
func spawn_new_block():
	print("Spawning new Block")
	
	var b = next_block
	
	var n = instantiate_random_block()
	set_next_block(n)
	b.position = Vector2(0,-300)
	selected_block = b
	add_child(b)

func _physics_process(delta):
	if(selected_block != null):
		if(!game_over):
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

	# currently, we do not allow to move the base
	if false:
		var base_velocity = 0
		if Input.is_action_pressed("move_base_left"):
			base_velocity -= 1
		if Input.is_action_pressed("move_base_right"):
			base_velocity += 1
		if base_velocity != 0:
			base_velocity = base_velocity * base_speed
			$Objects/Base_Plate.position.x += delta * base_velocity
			$Objects/StaticScaleBase.position.x += delta * base_velocity
			$Objects/ScalePinJoint2D.position.x += delta * base_velocity

		

func increase_score_multiplier(amount: float):
	score_multiplier += amount

func increase_score():
	if(!game_over):
		score += 1 * score_multiplier
		ScoreLabel.text = "Score: %s" % snapped(score,0.01)

func increase_lost_block_counter():
	if(!game_over):
		lost_blocks += 1
		LostBlockLabel.text = "Blocks Lost: %s" % lost_blocks

var time_out = 1
var time = time_out

#Increase Score 
func _process(delta: float) -> void:
	if lost_blocks >= game_over_amount and false == game_over:
		game_over = true
		game_over_label.visible = true
		high_score_label.text = "HighScore: %s" % snapped(score,0.01)
		high_score_label.visible = true
		exit_button.visible = true
		restart_button.visible = true
		for i in 5:
			spawn_new_block()
	if time > 0:
		time -= delta
	else:
		time = time_out
		increase_score()
