class_name Game
extends Control

const ACTION_SCENE: PackedScene = preload("res://game/actions/action.tscn")
const VALUE_DISPLAY_SCENE: PackedScene = preload("res://game/value_display/value_display.tscn")

@export var value_display_row: HBoxContainer
@export var actions_grid: GridContainer
@export var stats_manager: StatsManager
@export var action_data: Array[ActionData]

var value_displays: Array[ValueDisplay] = []
var actions: Array[Action] = []


func _ready() -> void:
	@warning_ignore("int_as_enum_without_cast")
	for stat: StatsManager.Stat in range(StatsManager.Stat.STAT_COUNT):
		create_value_label(stat)
	
	for action: ActionData in action_data:
		create_action(action)


func create_value_label(stat: StatsManager.Stat) -> void:
	var value_label: ValueDisplay = VALUE_DISPLAY_SCENE.instantiate()
	
	value_label.stats_manager = stats_manager
	value_label.stat = stat
	
	value_label.label_settings.font_color = stats_manager.STAT_COLORS[stat]
	
	value_label.display_stat(stats_manager.stats[stat])
	stats_manager._stat_changed.connect(value_label._on_stat_update)
	
	if not stats_manager.stat_visibility[stat]:
		value_label.hide()
	stats_manager._stat_visibility_changed.connect(value_label._on_stat_visibility_update)
	
	value_display_row.add_child(value_label)
	value_displays.append(value_label)


func create_action(data: ActionData) -> void:
	var action: Action = ACTION_SCENE.instantiate()
	
	action.name_label.text = data.name
	action.description_label.text = data.description
	
	action.button.text = data.button_text
	action.button.pressed.connect(stats_manager._try_action_stat_changes.bind(data))
	
	actions_grid.add_child(action)
	
	action.hide()
	data.unlock_condition._unlocked.connect(action.show)
	data.unlock_condition.stats_manager = stats_manager
	data.unlock_condition._setup()
