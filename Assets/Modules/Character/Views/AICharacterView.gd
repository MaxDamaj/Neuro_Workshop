extends CharacterView
class_name AICharacterView

@export var navAgent : NavigationAgent2D

signal on_target_reached

var moveAtPos : Vector2

func _ready() -> void:
	animator.speed_scale = 1.5
	animator.play("Idle")
	navAgent.target_reached.connect(_on_navigation_agent_2d_target_reached)
	navAgent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	can_move = true

func _physics_process(_delta):
	_calculate_movement()
	
	if (state == PlayerView.State.DEFEAT):
		return;
	
	var newState = State.IDLE_BACKWARD if state == State.RUN_BACKWARD || state == State.IDLE_BACKWARD else State.IDLE
	
	if (velocity != Vector2.ZERO):
		newState = State.RUN if velocity.y >= 0 else State.RUN_BACKWARD
	
	if (velocity.x != 0):
		root.scale = Vector2(-1 if velocity.x > 0 else 1, 1)
	
	_set_animation(newState)


func _calculate_movement():
	if (state == PlayerView.State.DEFEAT): return
	if (moveAtPos == Vector2.ZERO): return
	if (!can_move): return
	
	if (position.distance_to(moveAtPos) > 4):
		var curLoc = global_transform.origin
		var nextLoc = navAgent.get_next_path_position()
		var maxSpeed = speed
		var newVelocity = (nextLoc - curLoc).normalized() * maxSpeed
		
		if (navAgent.avoidance_enabled):
			navAgent.max_speed = maxSpeed
			navAgent.set_velocity(newVelocity)
		else:
			_on_navigation_agent_2d_velocity_computed(newVelocity)

func _on_navigation_agent_2d_target_reached():
	moveAtPos = Vector2.ZERO
	velocity = Vector2.ZERO
	on_target_reached.emit()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if (moveAtPos == Vector2.ZERO): return
	if (can_move):
		velocity = safe_velocity
		move_and_slide()
	else:
		velocity = Vector2.ZERO
