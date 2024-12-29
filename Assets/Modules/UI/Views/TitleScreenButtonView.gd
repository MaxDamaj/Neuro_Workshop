extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(_show_icon)
	self.mouse_exited.connect(_hide_icon)
	self.icon  = null
	
func _hide_icon()->void:
	self.icon  = null
	
func _show_icon()->void:
	if (self.disabled == false):
		self.icon = ResourceLoader.load("res://Assets/Textures/UI/pointer.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
