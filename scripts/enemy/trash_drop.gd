extends Node2D

func _ready() -> void:
	$drop_component.timer_length = randi() % 5 + 8
	$drop_component.fall_speed = randi() % 30 + 40

func timer_timeout_event():
	pass
	#self.queue_free()

func attacked():
	$drop_component._on_delete_timer_timeout()
