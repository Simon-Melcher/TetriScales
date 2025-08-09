extends Area2D

@export var lost_block_counter: Node

func _on_body_entered(body: Node) -> void:
	if body:  # Basic safety check
		body.queue_free()
		GlobalSignals.lost_block.emit()
