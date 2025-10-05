class_name Game
extends Control

const VALUE_DISPLAY_SCENE: PackedScene = preload("res://game/value_display/value_display.tscn")
const ACTION_LABEL_SCENE: PackedScene = preload("res://game/actions/action_label/action_label.tscn")
const ACTION_BUTTON_SCENE: PackedScene = preload(
		"res://game/actions/action_button/action_button.tscn")

@export var value_display_row: HBoxContainer
@export var actions_grid: GridContainer
@export var stats_manager: StatsManager
@export var actions: Array[Action]

var value_displays: Array[ValueDisplay] = []
var action_labels: Array[ActionLabel] = []
var action_buttons: Array[ActionButton] = []


func _ready() -> void:
	@warning_ignore("int_as_enum_without_cast")
	for stat: StatsManager.Stat in range(StatsManager.Stat.STAT_COUNT):
		create_value_label(stat)

	
	for action: Action in actions:
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


func create_action(action: Action) -> void:
	var action_label: ActionLabel = ACTION_LABEL_SCENE.instantiate()
	
	action_label.text = "%s: %s" % [action.name, action.description]
	
	actions_grid.add_child(action_label)
	action_labels.append(action_label)
	
	
	var action_button: ActionButton = ACTION_BUTTON_SCENE.instantiate()
	
	action_button.text = action.button_text
	action_button.pressed.connect(stats_manager._try_action_stat_changes.bind(action))
	
	actions_grid.add_child(action_button)
	action_buttons.append(action_button)
