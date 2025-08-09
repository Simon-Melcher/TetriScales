extends RigidBody2D

@export var friendly_name = "Block"

var detected_coliision = false
var damp_angular_velocity = false
@export var enable_angular_damping = false

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
			
