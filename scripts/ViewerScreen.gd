extends Container

onready var heartbeat = $MarginContainer/VerticalContainer/StatusContainer/HeartbeatContainer/HeartbeatData/Heartbeat
onready var power = $MarginContainer/VerticalContainer/StatusContainer/PowerContainer/PowerData/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/SpeedContainer/SpeedData/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/TimerContainer/TimerData/Seconds
onready var more = $MarginContainer/VerticalContainer/StatusContainer/DifficultyContainer/DifficultyData/More
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/DifficultyContainer/DifficultyData/Difficulty
onready var less = $MarginContainer/VerticalContainer/StatusContainer/DifficultyContainer/DifficultyData/Less

func _ready():
	print("[INFO] ViewerScreen: ready")
	pass

func update_data(data):
	print("[INFO] ViewerScreen: Updating data")
	
	heartbeat.text = str(data.heartbeat)
	power.text = str(data.power)
	speed.text = str(data.speed)
	
	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds
	
	if data.has_higher_difficulty:
		more.text = "/\\"
	else:
		more.text = ""
	
	if data.has_lesser_difficulty:
		less.text = "\\/"
	else:
		less.text = ""
	pass