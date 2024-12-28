extends CanvasLayer
class_name UILoadingPanel

@onready var _uiPanelsProvider : UIPanelsProvider = get_node(UIPanelsProvider.path)

@export var Bg : ColorRect

var _waitingTimer : Timer
var _end_func : Callable
var _timer : float
var _timerMaxValue : float = 0.7
var _isLoaded : bool

func _ready() -> void:
	_waitingTimer = Timer.new()
	_waitingTimer.one_shot = true
	add_child(_waitingTimer)
	_waitingTimer.timeout.connect(_waiting_timer_end)



func _process(delta: float) -> void:
	if (_timer > 0):
		_timer -= delta
		var fill_amount : float = _timer / _timerMaxValue if _isLoaded else 1 - (_timer / _timerMaxValue)
		Bg.material.set("shader_parameter/fill_amount", fill_amount)
		
		if (_timer <= 0):
			if (!_isLoaded):
				Bg.material.set("shader_parameter/fill_amount", 1)
				_waitingTimer.start(_timerMaxValue * 1.25)
				_end_func.call()
			else:
				_uiPanelsProvider.close_panel("loading_ui")


func init_args(args : Dictionary) -> void:
	_end_func = args["end_func"]
	_timer = _timerMaxValue

func _waiting_timer_end():
	_isLoaded = true
	_timer = _timerMaxValue
