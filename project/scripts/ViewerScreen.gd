extends Container

onready var power = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/PowerContainer/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/SpeedContainer/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Seconds
onready var more = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/More
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Difficulty
onready var less = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Less

func _ready():
	print("[INFO] ViewerScreen: ready")
	pass

func update_data(data):
	print("[INFO] ViewerScreen: Updating data")

	power.text = str(data.power)
	speed.text = str(data.speed)

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	if data.has_higher_difficulty:
		more.text = ">"
	else:
		more.text = ""

	difficulty.text = str(data.difficulty)

	if data.has_lesser_difficulty:
		less.text = "<"
	else:
		less.text = ""
	pass