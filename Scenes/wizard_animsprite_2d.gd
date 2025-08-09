extends AnimatedSprite2D

func _ready() -> void:	
	animation = "ride"
	play()
	


func _on_block_3x_1_gamedev_fade() -> void:
	animation = "fade"
	play()
