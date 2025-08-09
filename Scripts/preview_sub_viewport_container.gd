extends SubViewportContainer

var next_block = null

func _ready() -> void:
	#var c = %CanvasLayer
	pass
	
func set_next(block):
	if next_block:
		$SubViewport.remove_child(next_block)
		next_block = null
		
	$SubViewport/CanvasLayer/LabelNextPart.text = block.friendly_name
	# set next block in preview
	var vs = $SubViewport.get_viewport().size
	#var t = next_block.get_node("Sprite2D").texture
	#var bs = Vector2i(t.get_width(), t.get_height())
	#next_block.position = vs/2 - bs/2
	block.position = vs/2 
	$SubViewport.add_child(block)
	next_block = block
	
	
	
