class_name EventData
extends Resource

@export var name: String = ""
@export var description: String = ""
@export var action_1: ActionData = null
@export var action_2: ActionData = null
@export var unlock_condition: UnlockCondition = null
@export var lock_condition: UnlockCondition = null


func _init(p_name: String = "", p_description: String = "", p_action_1: ActionData = null,
		p_action_2: ActionData = null, p_unlock_condition: UnlockCondition = null,
		p_lock_condition: UnlockCondition = null) -> void:
	name = p_name
	description = p_description
	action_1 = p_action_1
	action_2 = p_action_2
	unlock_condition = p_unlock_condition
	lock_condition = p_lock_condition
