extends Node2D

var query = null

func debug_update():
	var unit = get_parent()
	if unit is preload("res://unit/Unit.gd"):
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			get_parent().global_position = get_global_mouse_position()
		query = UnitSpatialManager.get_cells_touching(unit.global_position,max(unit.coh_behaviour.radius_max,unit.sep_behaviour.radius_max))
		update()
func _enter_tree():
	UnitSpatialManager.connect("grid_updated",self,"debug_update")
func _exit_tree():
	UnitSpatialManager.disconnect("grid_updated",self,"debug_update")
func _draw():
	if query!=null:
		draw_line(
			to_local(get_parent().global_position),
			to_local(get_parent().global_position+get_parent().velocity),
			Color.purple,2.0,true
		)
		
		var vrect = get_viewport_rect()
		var max_radius = 0.0
		for B in get_parent().behaviours:
			max_radius = max(max_radius,B.radius_max)
#		for i in range(2):
#			var vi = Vector2.RIGHT.rotated(PI/2*i)
#			var small_vrect = Rect2(to_local(vrect.position + vi * max_radius), (vrect.size - vi * max_radius * 2))
#			draw_rect(small_vrect,Color.from_hsv(0.2+0.5*i,1.0,1.0),false,3.0)
		for q in get_parent().queries:
#			var qrect = Rect2(position-Vector2.ONE*get_parent().coh_behaviour.radius_max,Vector2.ONE*get_parent().coh_behaviour.radius_max*2)
			draw_arc(to_local(q.position),q.radius,0,TAU,36,Color.white*Color(1,1,1,0.3),1.0)
			for B in get_parent().behaviours:
				if B is SeperationBehaviour:
					draw_arc(to_local(q.position),B.radius_max,0,TAU,36,Color.red*Color(1,1,1,0.5),1.0)
				elif B is CohesionBehaviour:
					draw_arc(to_local(q.position),B.radius_max,0,TAU,36,Color.blue*Color(1,1,1,0.5),1.0)
				
					
		
