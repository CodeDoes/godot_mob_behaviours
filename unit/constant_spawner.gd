extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var spawns = []
var max_spawns = 100



func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.0001)
	for _i in range(max_spawns):
		do_spawn()
	timer.connect("timeout",self,"do_spawn",[],CONNECT_PERSIST)
	
	pass # Replace with function body.
func do_spawn():
	var vrect = get_viewport_rect()
	var unit = preload("res://unit/Unit.tscn").instance()
	add_child(unit)
	unit.global_position = (vrect.position)+vrect.size*Vector2(randf(),randf())*2.0-Vector2.ONE
	spawns.append(unit)
func _process(_d):
	while spawns.size()>max_spawns:
		spawns[0].queue_free()
		spawns.remove(0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
