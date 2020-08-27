extends NPC

class_name Enemy

var available_targets = []
var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	._integrate_forces(state)

func set_target(new_target:PhysicsBody2D):
	target_movement.set_target(new_target)

func find_next_target():
	# Get the next target, if one exists
	if !available_targets.empty():
		var nextTarget = available_targets.front()
		target_movement.set_target(nextTarget)
	else:
		# Pursue the base again
		target_movement.set_target(initial_target)

func add_available_target(new_target:PhysicsBody2D):
	available_targets.append(new_target)
	if !new_target.is_connected("die", self, "remove_target"):
		new_target.connect("die", self, "remove_target")
	
	# Note that this means the first target will always be priority
	if current_target == initial_target:
		set_target(new_target)

func remove_target(body:PhysicsBody2D):
	# Remove the target from the list
	if available_targets.has(body):
		available_targets.erase(body)
		if current_target == body:
			find_next_target()
