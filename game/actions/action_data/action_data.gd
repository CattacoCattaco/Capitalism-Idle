class_name ActionData
extends Resource

@export var name: String = ""
@export var description: String = ""
@export var button_text: String = ""

@export var stat_changes: Dictionary[StatsManager.Stat, int] = {}

@export var unlock_condition: UnlockCondition = null


func _init(p_name: String = "", p_description: String = "", p_button_text: String = "",
		p_stat_changes: Dictionary[StatsManager.Stat, int] = {},
		p_unlock_condition: UnlockCondition = null) -> void:
	name = p_name
	description = p_description
	button_text = p_button_text
	stat_changes = p_stat_changes
	unlock_condition = p_unlock_condition
