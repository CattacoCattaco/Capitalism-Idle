class_name ValueDisplay
extends Label

var stats_manager: StatsManager
var stat: StatsManager.Stat


func _on_stat_update(changed_stat: StatsManager.Stat, new_value: int) -> void:
	if changed_stat == stat:
		display_stat(new_value)


func display_stat(value: int) -> void:
	text = "%s: %d" % [stats_manager.STAT_NAMES[stat], value]


func _on_stat_visibility_update(changed_stat: StatsManager.Stat, visibility: bool) -> void:
	if changed_stat == stat:
		if visibility:
			show()
		else:
			hide()
