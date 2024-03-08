extends DampedSpringJoint2D

var node_1 = self
var node_2 = self

func _draw() -> void:

	draw_line(node_1.position, node_2.position, Color.white, 1.0)

func _physics_process(delta: float) -> void:
	update()
