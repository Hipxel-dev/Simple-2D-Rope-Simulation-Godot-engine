extends Node2D

var phys_obj = []

var phys_obj_dist = INF

var selected_phys_obj : RigidBody2D

onready var point = $point
onready var joint = $DampedSpringJoint2D

var amount = 160
var odd_number_getter = false

func _ready() -> void:
	for i in range(amount):
		var point_inst = point.duplicate()
		point_inst.position = Vector2(160, 32)
		point_inst.position += Vector2(0, 4 * i)
		add_child(point_inst)
		
		phys_obj.append(point_inst)
	
	for i in range(phys_obj.size() - 1):
		var joint_inst = joint.duplicate()
		joint_inst.set_node_a(phys_obj[i].get_path())
		joint_inst.set_node_b(phys_obj[i + 1].get_path())
		
		joint_inst.node_1 = get_node(joint_inst.node_a)
		joint_inst.node_2 = get_node(joint_inst.node_b)
		add_child(joint_inst)
		
	$point.queue_free()

func _draw() -> void:
	if Input.is_action_pressed("CLICK"):
		draw_arc(selected_phys_obj.position, 10, -PI, PI, 360, Color.white, 1.0)

func _physics_process(delta: float) -> void:
	update()
#	Engine.time_scale = 1.5
	phys_obj = get_tree().get_nodes_in_group("phys_obj")
	
	phys_obj[0].linear_velocity = phys_obj[0].linear_velocity.linear_interpolate(Vector2(100, 60), delta * 79)
#	phys_obj[phys_obj.size() - 1].position = Vector2(1000, 400)
	
	if Input.is_action_pressed("ui_accept"):
		for i in phys_obj:
			i.linear_velocity = i.linear_velocity.linear_interpolate(get_global_mouse_position() - i.position,delta * 15)
	
	if Input.is_action_just_pressed("CLICK"):
		selected_phys_obj = get_closest_phys_obj()
	if Input.is_action_pressed("CLICK"):
		selected_phys_obj.linear_velocity = selected_phys_obj.linear_velocity.linear_interpolate(get_global_mouse_position() - selected_phys_obj.position, delta * 79)
#		selected_phys_obj.position = get_global_mouse_position()
	
	for i in phys_obj:
		i.position.y = clamp(i.position.y, 0, 720)
		i.position.x = clamp(i.position.x, 0, 1280)
#		if i.position.x > 720:
#			i.linear_velocity.x = 0
	
func get_closest_phys_obj():
	var result = null
	
	phys_obj_dist = INF
	for i in phys_obj:
		var dist = i.position.distance_squared_to(get_global_mouse_position())
		if dist < phys_obj_dist:
			result = i
			phys_obj_dist = dist
	
	return result
