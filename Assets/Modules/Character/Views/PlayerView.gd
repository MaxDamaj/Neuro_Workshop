extends CharacterView
class_name PlayerView

func _physics_process(_delta):
	if (state == State.DEFEAT):
		return;
	
	var newState = State.IDLE_BACKWARD if state == State.RUN_BACKWARD || state == State.IDLE_BACKWARD else State.IDLE
	
	#move horizontal
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	if direction_horizontal:
		velocity.x = direction_horizontal * speed
		root.scale = Vector2(1 if direction_horizontal < 0 else -1, 1)
		newState = State.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#move vertical
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_vertical:
		velocity.y = direction_vertical * speed
		newState = State.RUN if direction_vertical > 0 else State.RUN_BACKWARD
	else:
		velocity.y = move_toward(velocity.y, 0, speed);
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	_set_animation(newState)
