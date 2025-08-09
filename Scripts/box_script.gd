extends RigidBody2D

var detected_coliision = false

func _ready() -> void:
	can_sleep = false
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body: Node) -> void:
	if(!detected_coliision and body != self):
		detected_coliision = true
		print("Emmiting Signal")
		GlobalSignals.spawn_newblock.emit()
