extends Container

onready var power = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/PowerContainer/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/SpeedContainer/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Seconds
onready var more = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/More
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Difficulty
onready var less = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Less
onready var athlete_skeleton = $MarginContainer/VerticalContainer/MotionContainer/AthleteContainer/Container/Viewport/Athlete/BodyScreen/rig/Skeleton

var bones = {
	76: [0,1,2],
	66: [0,1,2],
	65: [0,1,2],
	64: [0,1,2],
	63: [0,1,2],
	62: [1,2,0]
}

func _ready():
	print("[INFO] ViewerScreen: ready")
	pass

func update_data(data):
	#power.text = str(data.power)
	#speed.text = str(data.speed)
	power.text = str(data.athlete.l_thigh_1[0])
	speed.text = str(data.athlete.l_thigh_1[1])

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	#difficulty.text = str(data.difficulty)
	difficulty.text = str(data.athlete.l_thigh_1[2])

	if data.difficulty == 1:
		less.text = ""
		more.text = ">"
	elif data.difficulty == 2:
		more.text = "<"
		more.text = ">"
	else:
		less.text = "<"
		more.text = ""

	update_athlete(data)
	pass

func update_athlete(data):
	var angles = data.athlete.l_thigh_1
	for id in bones:
		var transform  = athlete_skeleton.get_bone_global_pose(id).orthonormalized()
		transform = transform.translated(Vector3(0.0, 0.0, 0.01))
		athlete_skeleton.set_bone_global_pose(id, transform)
	pass
