extends Node2D
	
		
var sep_behaviour
var coh_behaviour
var velocity = Vector2.ZERO
var queries = []
var behaviours = []
func _ready():
	sep_behaviour = SeperationBehaviour.new(0.0, 					16.0+16.0*1, 	-1000.0)
	coh_behaviour = CohesionBehaviour.new(sep_behaviour.radius_min, 16.0+16.0*10.0, +0500.0)
	behaviours = [sep_behaviour,coh_behaviour]
func movement_update():
	var container = get_parent()
	if container!=null:
#		var touching_datas = []
		var datas = {}
#		var behaviours = [sep_behaviour,coh_behaviour]
		var max_radius = 0.0
		for B in behaviours:
			B.velocity = Vector2.ZERO
			B.touching = 0
			max_radius = max(max_radius,B.radius_max)
		
		queries = [UnitSpatialManager.get_cells_touching(global_position,max_radius)]
		var vrect = get_viewport_rect()
		for i in range(2):
			var vi = Vector2.RIGHT.rotated(PI/2*i)
			var vo = vi.tangent()
			var small_vrect = Rect2(-vrect.position + vi * max_radius, vrect.size - vi * max_radius * 2)
			if not small_vrect.has_point(global_position):
				var diff = ((global_position-vrect.size/2)/2).posmodv(vrect.size/2)*2 - global_position
				var point =  (global_position + diff*2 * vi)
				queries.append(UnitSpatialManager.get_cells_touching(point, max_radius))
		if queries.size()==3:
			var vi = Vector2.ONE
			var diff = ((global_position-vrect.size/2)/2).posmodv(vrect.size/2)*2 - global_position
			var point =  (global_position + diff*2 * vi)
			queries.append(UnitSpatialManager.get_cells_touching(point, max_radius))
			
		for query in queries:
			for index in query.touching+query.encloses:
				for u in UnitSpatialManager.grid[index]:
					if not u == self:
						var diff = u.global_position - query.position
						var dist = diff.length()
						datas[u]={"diff":diff,"dist":dist}
		for data in datas.values():
			for B in behaviours:
				B.process_target(data.diff.normalized(),data.dist)
					
		velocity *= 0.99
		var delta = get_process_delta_time()
		for B in behaviours:
			if B.touching>0:
				var temp_vel:Vector2
				var mult
				velocity += (B.calc_target() - velocity) * delta
			
			
		global_position = ((global_position + velocity * delta)-vrect.position).posmodv(vrect.size)+vrect.position
func _process(_d):
	assert(self in UnitSpatialManager.units)
func _enter_tree():
	UnitSpatialManager.units.append(self)
	UnitSpatialManager.connect("grid_updated",self,"movement_update")
func _exit_tree():
	UnitSpatialManager.units.erase(self)
	UnitSpatialManager.disconnect("grid_updated",self,"movement_update")
	

