extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	update()


func _draw():
	if get_parent().grid_tree_root.size()>0:
		var root = get_parent().grid_tree_root.duplicate()
		root.v = 0
		root.depth = 0
		var branches = [root]
		while branches.size()>0:
			var b = branches.pop_back()
			var local_rect = Rect2(
				to_local(b.rect.position),
				b.rect.size#to_local()
			).grow(-0)#b.depth)
			if b.v==0:
				draw_rect(local_rect,Color.red*Color(1,1,1,0.5),false,1,true)
			else:
				draw_rect(local_rect,Color.blue*Color(1,1,1,0.5),false,1,true)
			if b.has("branches"):
				var sb
				sb = b.branches[0]
				sb.v = 0 
				sb.depth = b.depth+1
				branches.append(sb)

				sb = b.branches[1]
				sb.v = 1 
				sb.depth = b.depth+1
				branches.append(sb)
