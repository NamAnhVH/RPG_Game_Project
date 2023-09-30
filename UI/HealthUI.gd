extends HBoxContainer

onready var health_point = $HealthPoint
onready var health_point_label = $HealthPoint/Label

var player_stats = PlayerStats

func _ready():
	health_point.set_min(0)
	health_point.set_max(player_stats.max_health)
	health_point.set_value(player_stats.health)
	health_point_label.set_text(String(player_stats.health))
	player_stats.connect("new_health", self, "set_value")

func set_value(health):
	health_point.set_value(health)
	health_point_label.set_text(String(health))
