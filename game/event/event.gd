class_name Event
extends Panel

const ACTION_SCENE: PackedScene = preload("res://game/actions/action.tscn")

@export var name_label: Label
@export var description_label: Label
@export var action_holder: VBoxContainer
@export var action_1: Action
@export var action_2: Action

var stats_manager: StatsManager


func _load_event(data: EventData) -> void:
	get_tree().paused = true
	
	name_label.text = data.name
	description_label.text = data.description
	
	action_1.stats_manager = stats_manager
	action_2.stats_manager = stats_manager
	
	action_1.button.pressed.connect(unload)
	action_2.button.pressed.connect(unload)
	
	action_1.load_action(data.action_1)
	action_2.load_action(data.action_2)


func unload() -> void:
	get_tree().paused = false
	
	if action_1:
		action_1.queue_free()
		action_2.queue_free()
	
	action_1 = ACTION_SCENE.instantiate()
	action_2 = ACTION_SCENE.instantiate()
	
	action_holder.add_child(action_1)
	action_holder.add_child(action_2)
	
	hide()
