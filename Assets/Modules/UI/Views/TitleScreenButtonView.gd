extends Button
class_name TitleScreenButtonView


func _ready() -> void:
	self.mouse_entered.connect(_show_icon)
	self.mouse_exited.connect(_hide_icon)
	self.icon  = null
	
func _hide_icon()->void:
	self.icon  = null
	
func _show_icon()->void:
	if (self.disabled == false):
		self.icon = ResourceLoader.load("res://Assets/Textures/UI/pointer.png")
