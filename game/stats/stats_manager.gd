class_name StatsManager
extends Node

signal _stat_changed(stat: Stat, new_value: int)
signal _stat_visibility_changed(stat: Stat, visibility: bool)

## Each of the stats in the game
enum Stat {
	COINS,
	FLOWERS,
	PICKERS,
	FLOWER_SELLERS,
	DISORGANIZATION,
	MANAGERS,
	UNIONS,
	TRUST,
	WAGE_CUTS,
	SPEED_UP,
	STAT_COUNT ## Not a real stat but tells how many stats there are
}

const STAT_NAMES: Array[String] = [
	"Coins",
	"Flowers",
	"Pickers",
	"Flower Sellers",
	"Disorganization",
	"Managers",
	"Unions",
	"Internal Trust",
	"Wage cuts",
	"Bonus Efficiency",
]

const STAT_COLORS: Array[Color] = [
	Color(1, 1, 0),
	Color(1, 0.6, 0.8),
	Color(0.3, 1, 0),
	Color(0.3, 1, 0),
	Color(1, 0.1, 0.1),
	Color(0, 0.8, 1),
	Color(1, 0.1, 0.1),
	Color(0.2, 1, 0.9),
	Color(0.75, 1, 0),
	Color(0.75, 1, 0),
]

@export var work_timer: Timer
@export var wage_timer: Timer
@export var event_timer: Timer

var stats: Array[int] = [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	100,
	0,
	0,
]

var stat_visibility: Array[bool] = [
	true,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
]


func _ready() -> void:
	work_timer.timeout.connect(_calc_work)
	wage_timer.timeout.connect(_calc_wages)


func _calc_work() -> void:
	for i in range(stats[Stat.PICKERS]):
		if randf() < stats[Stat.DISORGANIZATION] / 1000.0:
			continue
		
		change_stat(Stat.FLOWERS, 1)
	
	for i in range(stats[Stat.FLOWER_SELLERS]):
		if randf() < stats[Stat.DISORGANIZATION] / 1000.0:
			continue
		
		_try_action_stat_changes(load("res://game/actions/action_data/sell_flowers.tres"))
	
	if _get_employee_count(0) > 10 * (_get_employee_count(1) + 1):
		var imbalance: int = floori(_get_employee_count(0) / 10.0) - _get_employee_count(1)
		change_stat(Stat.DISORGANIZATION, imbalance)
	elif stats[Stat.DISORGANIZATION] > 0:
		change_stat(Stat.DISORGANIZATION, -1)


func _calc_wages() -> void:
	var manager_wage: int = floor(30 * (1 - stats[Stat.WAGE_CUTS] / 100.0))
	while stats[Stat.COINS] < manager_wage * stats[Stat.MANAGERS]:
		change_stat(Stat.MANAGERS, -1)
	change_stat(Stat.COINS, -manager_wage * stats[Stat.MANAGERS])
	
	var picker_wage: int = floor(12 * (1 - stats[Stat.WAGE_CUTS] / 100.0))
	while stats[Stat.COINS] < picker_wage * stats[Stat.PICKERS]:
		change_stat(Stat.PICKERS, -1)
	change_stat(Stat.COINS, -picker_wage * stats[Stat.PICKERS])
	
	var flower_seller_wage: int = floor(15 * (1 - stats[Stat.WAGE_CUTS] / 100.0))
	while stats[Stat.COINS] < flower_seller_wage * stats[Stat.FLOWER_SELLERS]:
		change_stat(Stat.FLOWER_SELLERS, -1)
	change_stat(Stat.COINS, -flower_seller_wage * stats[Stat.FLOWER_SELLERS])


func _get_employee_count(tier: int) -> int:
	match tier:
		0:
			return (stats[Stat.PICKERS]
					+ stats[Stat.FLOWER_SELLERS])
		1:
			return (stats[Stat.MANAGERS])
	
	return 0


func _try_action_stat_changes(action: ActionData) -> void:
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
	
	if stat == Stat.SPEED_UP:
		work_timer.wait_time = 60.0 / (60 + 5 * stats[Stat.SPEED_UP])


func change_stat_visibility(stat: Stat, visibility: bool) -> void:
	if stat_visibility[stat] == visibility:
		return
	
	stat_visibility[stat] = visibility
	_stat_visibility_changed.emit(stat, visibility)
