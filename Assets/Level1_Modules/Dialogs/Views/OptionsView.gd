extends Control
class_name OptionsView

@export var optionButton : PackedScene

signal on_option_selected(dialogId : String)

var isBusy : bool = false

var _options : Array[Button]


func _ready() -> void:
	modulate = Color(1, 1, 1, 0)

func show_phrase(phrase : DialogPhraseModel):
	for button in _options:
		button.queue_free()
	_options.clear()
	
	for option : String in phrase.options:
		var button : Button = optionButton.instantiate()
		add_child(button)
		var split = option.split('|')
		button.text = split[0]
		
		button.button_down.connect(func(): _move_to_dialog(split[1]))
	
	isBusy = true
	modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween()
	var target_color = Color.WHITE
	tween.tween_property(self, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		modulate = target_color
	)

func _move_to_dialog(dialogId : String):
	isBusy = false
	on_option_selected.emit(dialogId)
	_close_view()

func _close_view():
	var tween = create_tween()
	var target_color = Color(1, 1, 1, 0)
	tween.tween_property(self, "modulate", target_color, 0.5)
	tween.tween_callback(func():
		modulate = target_color
	)
