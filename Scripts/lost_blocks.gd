extends Label

var lost_block_counter = 0

func increase_lost_block_counter():
	lost_block_counter += 1
	text = "Blocks Lost: %s" % lost_block_counter
