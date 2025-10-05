@abstract
class_name UnlockCondition
extends Resource

signal _unlocked()

var is_unlocked: bool = false

var stats_manager: StatsManager

@abstract func _setup() -> void

func _unlock() -> void:
	is_unlocked = true
	_unlocked.emit()
