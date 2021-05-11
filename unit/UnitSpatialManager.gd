extends Node


var units = []
var grid:Dictionary
var grid_tree_root:Dictionary
var snap = 16.0
signal grid_updated
#func _ready():
#	units = []
func _generate_tree():
	var branches = [grid_tree_root]
	while branches :
		var branch = branches.pop_front()
		var min_indexes = []
		var max_indexes = []
		var subbranches:Array
		var center = Vector2.ZERO
		var rect_1:Rect2
		var rect_2:Rect2
		var axis = Vector2.ZERO
		var opaxis = Vector2.ZERO
		var y_more_than_x = branch.rect.size.y>branch.rect.size.x
		if not y_more_than_x:
			axis = Vector2(1,0)
			opaxis = Vector2(0,1)
		else:
			axis = Vector2(0,1)
			opaxis = Vector2(1,0)
		for index in branch.indexes:
			center += index
		center = center
		center /= float(branch.indexes.size())
		var axis_center = center * axis
		if branch.indexes.size()>10:
			for index in branch.indexes:
				var vec = (index*axis)
				if (vec.x+vec.y) < (axis_center.x+axis_center.y):
					min_indexes.append(index)
				else:
					max_indexes.append(index)
			if min_indexes.size()!=0 and max_indexes.size()!=0:
				rect_1 = Rect2(
					branch.rect.position,
					branch.rect.size * opaxis + (axis_center - branch.rect.position * axis)
				)
				
				rect_2 = Rect2(
					branch.rect.position + rect_1.size * axis,
					branch.rect.size * opaxis + (branch.rect.size * axis-rect_1.size * axis)
				)
				branch.branches = [
					{"rect":rect_1,"indexes":min_indexes},
					{"rect":rect_2,"indexes":max_indexes}
				]
				branches.append_array(branch.branches)
func _generate_grid():
	grid = {}
	var snap_vec = Vector2.ONE*snap
	for u in units:
		var index = u.global_position.snapped(snap_vec)
		grid[index] = grid.get(index,[])+[u]
	var min_pos = +Vector2(INF,INF)
	var max_pos = -Vector2(INF,INF)
	for index in grid.keys():
		min_pos.x = min(min_pos.x,index.x-snap)
		min_pos.y = min(min_pos.y,index.y-snap)
		
		max_pos.x = max(max_pos.x,index.x+snap)
		max_pos.y = max(max_pos.y,index.y+snap)
	var grid_tree_root_rect = Rect2(min_pos.floor(),max_pos-min_pos)
	grid_tree_root_rect.size = grid_tree_root_rect.size.ceil()
	grid_tree_root = {"rect":grid_tree_root_rect,"indexes":grid.keys()}
	
	
func _process(_delta):
	_generate_grid()
	_generate_tree()
	emit_signal("grid_updated")
func get_cells_touching(position:Vector2,radius:float):
	var qrect = Rect2(position-Vector2.ONE*radius,Vector2.ONE*radius*2)
	var branches = [grid_tree_root]
	var result = {
		"encloses":[],
		"touching":[],
		"position":position,
		"radius":radius
	}
	while branches.size()>0:
		var branch = branches.pop_front()
		if qrect.encloses(branch.rect):
			result.encloses.append_array(branch.indexes)
		elif qrect.intersects(branch.rect) or branch.rect.encloses(qrect):
			if branch.has("branches"):
				branches.append_array(branch.branches)
			else:
				result.touching.append_array(branch.indexes)
	return result
	
