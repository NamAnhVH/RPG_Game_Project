extends TextureRect

onready var atk_label = $AtkLabel
onready var def_label = $DefLabel
onready var crit_rate_label = $CritRateLabel
onready var crit_damage_label = $CritDamageLabel
onready var attack_speed_label = $AttackSpeedLabel
onready var max_health_label = $MaxHealthLabel
onready var max_energy_label = $MaxEnergyLabel
onready var speed_label = $SpeedLabel
onready var knockback_label = $KnockbackLabel

func _ready():
	atk_label.text = "ATK: " + str(PlayerStats.get_atk())
	def_label.text = "DEF: " + str(PlayerStats.get_def())
	crit_rate_label.text = "CRIT RATE: " + str(PlayerStats.get_crit_rate())
	crit_damage_label.text = "CRIT DAMAGE: " + str(PlayerStats.get_crit_damage())
	attack_speed_label.text = "ATTACK SPEED: " + str(PlayerStats.get_attack_speed()) 
	max_health_label.text = "MAX HEALTH: " + str(PlayerStats.get_max_health())
	max_energy_label.text = "MAX ENERGY: " + str(PlayerStats.get_max_energy())
	speed_label.text = "SPEED: " + str(PlayerStats.get_attack_speed())
	knockback_label.text = "KNOCKBACK: " + str(PlayerStats.get_knockback())
