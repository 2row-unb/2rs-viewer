extends Container

onready var power = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/PowerContainer/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/SpeedContainer/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Seconds
onready var more = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/More
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Difficulty
onready var less = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Less
onready var athlete_skeleton = $MarginContainer/VerticalContainer/MotionContainer/AthleteContainer/Container/Viewport/Athlete/BodyScreen/Armature/Skeleton
onready var ideal_skeleton = $MarginContainer/VerticalContainer/MotionContainer/IdealContainer/Container/Viewport/Ideal/BodyScreen/Armature/Skeleton

const UPPER_ARM_L = 3
const UPPER_LEG_L = 29
const LOWER_LEG_L = 30

const UPPER_ARM_R = 16
const UPPER_LEG_R = 32

var base_transforms = {}

func _ready():
	print("[INFO] ViewerScreen: ready")
	set_default_pose(athlete_skeleton)
	set_default_pose(ideal_skeleton)
	pass

func update_data(data):
	power.text = str(data.power)
	speed.text = str(data.speed)
	# power.text = str(data.athlete.l_thigh_1[0])
	# speed.text = str(data.athlete.l_thigh_1[1])

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	difficulty.text = str(data.difficulty)
	# difficulty.text = str(data.athlete.l_thigh_1[2])

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
	var transform = base_transforms[UPPER_LEG_L]
	transform = transform.rotated(Vector3(0.0, 1.0, 0.0), angles[1])
	transform = transform.rotated(Vector3(0.0, 0.0, 1.0), angles[2])
	transform = transform.rotated(Vector3(1.0, 0.0, 0.0), angles[0])
	# var transform = base_transforms[LOWER_LEG_L]
	# transform = transform.rotated(Vector3(0.0,1.0,0.0), PI/1.5)
	# athlete_skeleton.set_bone_pose(LOWER_LEG_L, transform)
	# transform = base_transforms[UPPER_LEG_L]
	# transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/4)
	athlete_skeleton.set_bone_pose(UPPER_LEG_L, transform)
	pass

func set_default_pose(skeleton):
	set_default_left_upper_arm(skeleton)
	set_default_left_upper_leg(skeleton)
	set_default_left_hand(skeleton)
	set_default_right_upper_arm(skeleton)
	set_default_right_upper_leg(skeleton)
	set_default_right_hand(skeleton)
	base_transforms[LOWER_LEG_L] = athlete_skeleton.get_bone_pose(LOWER_LEG_L)
	pass

func set_default_left_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(UPPER_ARM_L)
	transform = transform.rotated(Vector3(0.0,0.0,1.0), -PI/3)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(UPPER_ARM_L, transform)
	base_transforms[UPPER_ARM_L] = transform
	pass

func set_default_right_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(UPPER_ARM_R)
	transform = transform.rotated(Vector3(0.0,0.0,1.0), PI/3)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(UPPER_ARM_R, transform)
	base_transforms[UPPER_ARM_R] = transform
	pass

func set_default_left_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(UPPER_LEG_L)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(UPPER_LEG_L, transform)
	base_transforms[UPPER_LEG_L] = transform
	pass

func set_default_right_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(UPPER_LEG_R)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(UPPER_LEG_R, transform)
	base_transforms[UPPER_LEG_R] = transform
	pass

func set_default_left_hand(skeleton):
	for id in range(8, 16):
		var transform = skeleton.get_bone_pose(id)
		transform = transform.rotated(Vector3(1.0,0.0,0.0), -PI/3)
		skeleton.set_bone_pose(id, transform)
		base_transforms[id] = transform
	pass

func set_default_right_hand(skeleton):
	for id in range(21, 29):
		var transform = skeleton.get_bone_pose(id)
		transform = transform.rotated(Vector3(1.0,0.0,0.0), PI/3)
		skeleton.set_bone_pose(id, transform)
		base_transforms[id] = transform
	pass
