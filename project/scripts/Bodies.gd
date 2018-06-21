extends Node

onready var athlete_skeleton = $Athlete/Armature/Skeleton
onready var ideal_skeleton = $Ideal/Armature/Skeleton

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

const X = Vector3(1.0, 0.0, 0.0)
const Y = Vector3(0.0, 1.0, 0.0)
const Z = Vector3(0.0, 0.0, 1.0)

var base_transforms = {}
var ideal_root_variation = [0.0, 0.0, 0.0]
var athlete_root_variation = [0.0, 0.0, 0.0]

var ideal_step = 0
var increasing = true

func _ready():
	print("[INFO] Bodies: ready")
	set_default_root()
	set_default_pose(athlete_skeleton)
	set_default_pose(ideal_skeleton)
	pass

func update_data(data):
	update_body(athlete_skeleton, data.athlete)

	#update_ideal_by_ratio()

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
	# translate(ideal_skeleton, ROOT, [0.0, 0.39*ideal_step, -0.1*ideal_step])
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
		transform = transform.rotated(Y, angles[1])
		transform = transform.rotated(Z, angles[2])
		transform = transform.rotated(X, angles[0])
	else:
		transform = transform.rotated(X, angles[0])
		transform = transform.rotated(Y, angles[1])
		transform = transform.rotated(Z, angles[2])
	skeleton.set_bone_pose(bone, transform)
	pass

func translate(skeleton, bone, delta):
	var transform = base_transforms[bone]
	transform = transform.translated(Vector3(delta[0], delta[1], delta[2]))
	skeleton.set_bone_pose(bone, transform)
	pass

# Default

func set_default_pose(skeleton):
	set_default_head(skeleton)

	set_default_left_upper_arm(skeleton)
	set_default_left_hand(skeleton)

	set_default_right_upper_arm(skeleton)
	set_default_right_hand(skeleton)

	set_default_left_upper_leg(skeleton)
	base_transforms[LEG_LL] = athlete_skeleton.get_bone_pose(LEG_LL)
	base_transforms[FOOT_L] = athlete_skeleton.get_bone_pose(FOOT_L)

	set_default_right_upper_leg(skeleton)
	base_transforms[LEG_LR] = athlete_skeleton.get_bone_pose(LEG_LR)
	base_transforms[FOOT_R] = athlete_skeleton.get_bone_pose(FOOT_R)
	pass

func set_default_left_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(ARM_UL)
	transform = transform.rotated(Z, -PI/3)
	transform = transform.rotated(Y, -PI/2)
	skeleton.set_bone_pose(ARM_UL, transform)
	base_transforms[ARM_UL] = transform
	pass

func set_default_right_upper_arm(skeleton):
	var transform = skeleton.get_bone_pose(ARM_UR)
	transform = transform.rotated(Z, PI/3)
	transform = transform.rotated(Y, -PI/2)
	skeleton.set_bone_pose(ARM_UR, transform)
	base_transforms[ARM_UR] = transform
	pass

func set_default_left_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UL)
	transform = transform.rotated(Y, -PI/4)
	skeleton.set_bone_pose(LEG_UL, transform)
	base_transforms[LEG_UL] = transform
	pass

func set_default_right_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UR)
	transform = transform.rotated(Y, -PI/4)
	skeleton.set_bone_pose(LEG_UR, transform)
	base_transforms[LEG_UR] = transform
	pass

func set_default_left_hand(skeleton):
	for id in range(8, 16):
		var transform = skeleton.get_bone_pose(id)
		transform = transform.rotated(X, -PI/3)
		skeleton.set_bone_pose(id, transform)
		base_transforms[id] = transform
	pass

func set_default_right_hand(skeleton):
	for id in range(21, 29):
		var transform = skeleton.get_bone_pose(id)
		transform = transform.rotated(X, PI/3)
		skeleton.set_bone_pose(id, transform)
		base_transforms[id] = transform
	pass

func set_default_head(skeleton):
	var transform = skeleton.get_bone_pose(HEAD)
	transform = transform.rotated(X, -PI/4)
	skeleton.set_bone_pose(HEAD, transform)
	base_transforms[HEAD] = transform
	pass

func set_default_root():
	var transform = athlete_skeleton.get_bone_pose(ROOT)
	base_transforms[ROOT] = transform
	transform = transform.rotated(X, -PI/4)
	athlete_root_variation = [-PI/4, 0.0, 0.0]
	ideal_root_variation = [-PI/4, 0.0, 0.0]
	athlete_skeleton.set_bone_pose(ROOT, transform)
	ideal_skeleton.set_bone_pose(ROOT, transform)
	pass
