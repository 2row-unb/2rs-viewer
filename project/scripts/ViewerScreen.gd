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

const ARM_UL = 3
const ARM_UR = 16

const LEG_UL = 29
const LEG_LL = 30
const LEG_UR = 32
const LEG_LR = 33

const FOOT_L = 31
const FOOT_R = 34

const HEAD = 2

const CHEST = 1

const ROOT = 0

const IDEAL_TOTAL_STEPS = 14

var base_transforms = {}

var ideal_step = 0
var increasing = true

func _ready():
	print("[INFO] ViewerScreen: ready")
	set_default_pose(athlete_skeleton)
	set_default_pose(ideal_skeleton)
	pass

func update_data(data):
	power.text = str(data.power)
	speed.text = str(data.speed)

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	difficulty.text = str(data.difficulty)

	if data.difficulty < 1:
		less.text = ""
		more.text = ">"
	elif data.difficulty < 3:
		more.text = "<"
		more.text = ">"
	else:
		less.text = "<"
		more.text = ""

	update_body(athlete_skeleton, data.athlete)

	#update_body(ideal_skeleton, IDEAL_MOVEMENTS[ideal_step])
	update_ideal_by_ratio()

	if increasing:
		ideal_step += 1
	else:
		ideal_step -= 1

	if ideal_step == -1:
		increasing = true
		ideal_step = 1
	elif ideal_step == IDEAL_TOTAL_STEPS:
		increasing = false
		ideal_step = IDEAL_TOTAL_STEPS-2
	pass

func update_ideal_by_ratio():
	rotate(ideal_skeleton, FOOT_L, [(PI*ideal_step)/35, 0.0, 0.0], false)
	rotate(ideal_skeleton, FOOT_R, [(PI*ideal_step)/35, 0.0, 0.0], true)
	rotate(ideal_skeleton, LEG_UL, [0.0, (-PI*ideal_step)/40, 0.0], false)
	rotate(ideal_skeleton, LEG_LL, [0.0, (PI*ideal_step)/16, 0.0], false)
	rotate(ideal_skeleton, LEG_UR, [0.0, (-PI*ideal_step)/40, 0.0], true)
	rotate(ideal_skeleton, LEG_LR, [0.0, (PI*ideal_step)/16, 0.0], true)
	translate(ideal_skeleton, ROOT, [0.0, 0.39*ideal_step, -0.1*ideal_step])
	pass

func update_body(skeleton, bones):
	update_legs(skeleton, bones.legs)
	update_root(skeleton, bones.root)
	pass

func update_legs(skeleton, legs):
	rotate(skeleton, LEG_UL, legs.ul, false)
	rotate(skeleton, LEG_LL, legs.ll, false)
	rotate(skeleton, LEG_UR, legs.ur, true)
	rotate(skeleton, LEG_LR, legs.lr, true)
	pass

func update_root(skeleton, root):
	translate(skeleton, ROOT, root)
	pass

# Transforms

func rotate(skeleton, bone, angles, is_right_side):
	var transform = base_transforms[bone]
	if(is_right_side):
		transform = transform.rotated(Vector3(0.0, 1.0, 0.0), angles[1])
		transform = transform.rotated(Vector3(0.0, 0.0, 1.0), angles[2])
		transform = transform.rotated(Vector3(1.0, 0.0, 0.0), angles[0])
	else:
		transform = transform.rotated(Vector3(1.0, 0.0, 0.0), angles[0])
		transform = transform.rotated(Vector3(0.0, 1.0, 0.0), angles[1])
		transform = transform.rotated(Vector3(0.0, 0.0, 1.0), angles[2])
	skeleton.set_bone_pose(bone, transform)
	pass

func translate(skeleton, bone, delta):
	var transform = base_transforms[bone]
	transform = transform.translated(Vector3(delta[0], delta[1], delta[2]))
	skeleton.set_bone_pose(bone, transform)
	pass

# Default

func set_default_pose(skeleton):
	set_default_left_hand(skeleton)
	set_default_left_upper_arm(skeleton)

	set_default_right_hand(skeleton)
	set_default_right_upper_arm(skeleton)

	base_transforms[FOOT_L] = athlete_skeleton.get_bone_pose(FOOT_L)
	set_default_left_upper_leg(skeleton)

	base_transforms[FOOT_R] = athlete_skeleton.get_bone_pose(FOOT_R)
	set_default_right_upper_leg(skeleton)

	base_transforms[LEG_LL] = athlete_skeleton.get_bone_pose(LEG_LL)
	base_transforms[LEG_LR] = athlete_skeleton.get_bone_pose(LEG_LR)

	set_default_head(skeleton)

	base_transforms[ROOT] = athlete_skeleton.get_bone_pose(ROOT)
	pass

func set_default_left_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(ARM_UL)
	transform = transform.rotated(Vector3(0.0,0.0,1.0), -PI/3)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(ARM_UL, transform)
	base_transforms[ARM_UL] = transform
	pass

func set_default_right_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(ARM_UR)
	transform = transform.rotated(Vector3(0.0,0.0,1.0), PI/3)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(ARM_UR, transform)
	base_transforms[ARM_UR] = transform
	pass

func set_default_left_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UL)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(LEG_UL, transform)
	base_transforms[LEG_UL] = transform
	pass

func set_default_right_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UR)
	transform = transform.rotated(Vector3(0.0,1.0,0.0), -PI/2)
	skeleton.set_bone_pose(LEG_UR, transform)
	base_transforms[LEG_UR] = transform
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

func set_default_head(skeleton):
	var transform = skeleton.get_bone_pose(HEAD)
	transform = transform.rotated(Vector3(1.0,0.0,0.0), 0.0)
	skeleton.set_bone_pose(HEAD, transform)
	base_transforms[HEAD] = transform
	pass

func set_default_chest(skeleton):
	var transform = skeleton.get_bone_pose(CHEST)
	transform = transform.rotated(Vector3(1.0,0.0,0.0), 0.0)
	skeleton.set_bone_pose(CHEST, transform)
	base_transforms[CHEST] = transform
	pass
