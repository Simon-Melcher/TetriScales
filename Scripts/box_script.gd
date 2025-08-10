extends RigidBody2D

signal fade

@export var friendly_name = "Block"
@export var allow_random_rotation = true
@export var allow_flip_h = false

var detected_coliision = false
var damp_angular_velocity = false
@export var enable_angular_damping = false

const impact_particle = preload("res://Ressources/impact_particles.tscn")

var state_for_collision = null

func _ready() -> void:
	can_sleep = false
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body: Node) -> void:
	if(!detected_coliision and body != self):
		detected_coliision = true
		print("Emmiting Signal")
		GlobalSignals.play_block_sound.emit()
		GlobalSignals.spawn_newblock.emit()
		
		fade.emit()
		#Spawn Impact Particle at Collision Point
		if(self.get_contact_count() >= 1 and state_for_collision != null and !GlobalSignals.game_over_screen):  #this check is needed or it will throw errors 
			var particle = impact_particle.instantiate()
			add_child(particle)
			particle.global_position = state_for_collision.get_contact_collider_position(0)
			particle.emitting = true
		if enable_angular_damping:
			damp_angular_velocity = true
			var timer = Timer.new()
			timer.wait_time = 1
			add_child(timer)
			timer.timeout.connect(stop_angular_velocity_damping)
			timer.start()

func stop_angular_velocity_damping() -> void:
	damp_angular_velocity = false
	
func _physics_process(delta: float) -> void:
	if true: # Input.is_action_pressed("debug"):
		if damp_angular_velocity:
			angular_velocity = angular_velocity * 0.80
			
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state_for_collision = state
