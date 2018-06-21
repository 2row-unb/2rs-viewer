extends Spatial

onready var athlete_skeleton = $Armature/Skeleton

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

const X = Vector3(1.0, 0.0, 0.0)
const Y = Vector3(0.0, 1.0, 0.0)
const Z = Vector3(0.0, 0.0, 1.0)

var base_transforms = {}
var athlete_root_variation = [0.0, 0.0, 0.0]

func _ready():
	print("[INFO] ViewerScreen: ready")
	set_default_pose(athlete_skeleton)
	pass

func update_data(data):
	update_body(athlete_skeleton, data.athlete)
	pass

func update_body(skeleton, bones):
	update_legs(skeleton, bones.legs)
	pass

func update_legs(skeleton, legs):
	rotate(skeleton, LEG_UL, legs.ul, false)
	rotate(skeleton, LEG_LL, legs.ll, false)
	rotate(skeleton, LEG_UR, legs.ur, true)
	rotate(skeleton, LEG_LR, legs.lr, true)
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
	set_default_left_upper_leg(skeleton)
	base_transforms[LEG_LL] = athlete_skeleton.get_bone_pose(LEG_LL)
	base_transforms[FOOT_L] = athlete_skeleton.get_bone_pose(FOOT_L)

	set_default_right_upper_leg(skeleton)
	base_transforms[LEG_LR] = athlete_skeleton.get_bone_pose(LEG_LR)
	base_transforms[FOOT_R] = athlete_skeleton.get_bone_pose(FOOT_R)
	pass

func set_default_left_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UL)
	transform = transform.rotated(Y, -PI/2)
	skeleton.set_bone_pose(LEG_UL, transform)
	base_transforms[LEG_UL] = transform
	pass

func set_default_right_upper_leg(skeleton):
	var transform = skeleton.get_bone_pose(LEG_UR)
	transform = transform.rotated(Y, -PI/2)
	skeleton.set_bone_pose(LEG_UR, transform)
	base_transforms[LEG_UR] = transform
	pass
