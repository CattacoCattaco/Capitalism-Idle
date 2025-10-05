class_name ValueDisplay
extends Label

var stats_manager: StatsManager
var stat: StatsManager.Stat


func _on_stat_update(changed_stat: StatsManager.Stat, new_value: int):
	if changed_stat == stat:
		display_stat(new_value)


func display_stat(value: int):
	text = "%s: %d" % [stats_manager.STAT_NAMES[stat], value]
	print(text)


func _on_stat_visibility_update(changed_stat: StatsManager.Stat, visibility: bool):
	if changed_stat == stat:
		if visibility:
			show()
		else:
			hide()
