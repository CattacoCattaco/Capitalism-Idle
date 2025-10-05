class_name StatsManager
extends Node

signal _stat_changed(stat: Stat, new_value: int)
signal _stat_visibility_changed(stat: Stat, visibility: bool)

## Each of the stats in the game
enum Stat {
	COINS,
	FLOWERS,
	STAT_COUNT ## Not a real stat but tells how many stats there are
}

const STAT_NAMES: Array[String] = [
	"Coins",
	"Flowers",
]

const STAT_COLORS: Array[Color] = [
	Color(1, 1, 0),
	Color(1, 0.6, 0.8),
]

var stats: Array[int] = [
	0,
	0,
]

var stat_visibility: Array[bool] = [
	true,
	false,
]


func _try_action_stat_changes(action: Action) -> void:
	# Can all negative changes (costs) be fulfilled?
	var all_negatives_pass: bool = true
	
	for stat in action.stat_changes:
		var change: int = action.stat_changes[stat]
		if stats[stat] < -change:
			all_negatives_pass = false
	
	if all_negatives_pass:
		for stat in action.stat_changes:
			var change: int = action.stat_changes[stat]
			change_stat(stat, change)


func change_stat(stat: Stat, change: int) -> void:
	set_stat(stat, stats[stat] + change)


func set_stat(stat: Stat, value: int) -> void:
	stats[stat] = value
	_stat_changed.emit(stat, stats[stat])
	
	if (not stat_visibility[stat]) and stats[stat] != 0:
		change_stat_visibility(stat, true)


func change_stat_visibility(stat: Stat, visibility: bool) -> void:
	if stat_visibility[stat] == visibility:
		return
	
	stat_visibility[stat] = visibility
	_stat_visibility_changed.emit(stat, visibility)
