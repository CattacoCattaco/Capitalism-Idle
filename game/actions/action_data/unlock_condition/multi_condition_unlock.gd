class_name MultiConditionUnlock
extends UnlockCondition

@export var unlock_conditions: Array[UnlockCondition] = []

var _unlock_successes: Array[bool] = []


func _setup() -> void:
	for i in len(unlock_conditions):
		unlock_conditions[i]._unlocked.connect(_successful_unlock.bind(i))
		unlock_conditions[i]._setup()
		_unlock_successes.append(false)


func _successful_unlock(index: int) -> void:
	_unlock_successes[index] = true
	
	var all_unlocked: bool = true
	for success: bool in _unlock_successes:
		if not success:
			all_unlocked = false
	
	if all_unlocked:
		_unlock()
