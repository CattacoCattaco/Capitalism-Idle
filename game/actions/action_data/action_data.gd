class_name ActionData
extends Resource

@export var name: String = ""
@export var description: String = ""
@export var button_text: String = ""

@export var stat_changes: Dictionary[StatsManager.Stat, int] = {}


func _init(p_name: String = "", p_description: String = "", p_button_text: String = "",
		p_stat_changes: Dictionary[StatsManager.Stat, int] = {}) -> void:
	name = p_name
	description = p_description
	button_text = p_button_text
	stat_changes = p_stat_changes
