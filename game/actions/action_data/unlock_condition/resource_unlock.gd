class_name ResourceUnlock
extends UnlockCondition

enum ReqType {
	MIN,
	MAX,
	EXACT
}

@export var stat: StatsManager.Stat
@export var req: int
@export var type: ReqType


func _on_stat_update(changed_stat: StatsManager.Stat, value: int) -> void:
	if changed_stat != stat:
		return
	
	match type:
		ReqType.MIN:
			if value <= req:
				stats_manager._stat_changed.disconnect(_on_stat_update)
				_unlock()
		ReqType.MAX:
			if value >= req:
				stats_manager._stat_changed.disconnect(_on_stat_update)
				_unlock()
		ReqType.EXACT:
			if value == req:
				stats_manager._stat_changed.disconnect(_on_stat_update)
				_unlock()


func _setup() -> void:
	stats_manager._stat_changed.connect(_on_stat_update)
