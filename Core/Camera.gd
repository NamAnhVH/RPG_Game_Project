extends Camera2D

onready var top_position = $Limit/TopPosition.position
onready var bottom_position = $Limit/BottomPosition.position

func _ready():
	limit_left = top_position.x;
	limit_top = top_position.y;
	limit_right = bottom_position.x;
	limit_bottom = bottom_position.y;
