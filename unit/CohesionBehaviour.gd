class_name CohesionBehaviour
var force:float
var touching:int
var velocity:Vector2
var radius_max
var radius_min
func _init(_radius_min, _radius_max,_force):
	radius_max = _radius_max
	radius_min = _radius_min
	force = _force
	touching = 0
	velocity = Vector2.ZERO
func calc_target():
	return velocity.normalized() * (velocity.length()/touching)  * force
	
func process_target(direction,distance):
	if distance < radius_max and distance>radius_min:
		velocity += direction * ((distance - radius_min) / (radius_max-radius_min))
		touching += 1
