extends RigidBody2D

var detected_coliision = false

func _on_body_entered(body: Node) -> void:
	if(!detected_coliision and body != self):
		detected_coliision = true
		print("Emmiting Signal")
		GlobalSignals.spawn_newblock.emit()
