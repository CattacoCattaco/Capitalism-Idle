class_name Action
extends Panel

@export var name_label: Label
@export var description_label: Label
@export var button: Button

var stats_manager: StatsManager


func load_action(data: ActionData) -> void:
	data = data.duplicate(true)
	
	name_label.text = data.name
	description_label.text = data.description
	
	button.text = data.button_text

	button.pressed.connect(stats_manager._try_action_stat_changes.bind(data))
	
	hide()
	data.unlock_condition._unlocked.connect(show)
	data.unlock_condition.stats_manager = stats_manager
	data.unlock_condition._setup()
