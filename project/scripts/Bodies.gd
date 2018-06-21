extends Node

class BodyData:
	var bases = {}
	var skeleton = null

const ARM_UL = 3
const ARM_LL = 4
const ARM_UR = 16
const ARM_LR = 17

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

var ideal_step = 0
var step_increasing = true
var athlete = BodyData.new()
var ideal = BodyData.new()

func _ready():
	print("[INFO] Bodies: ready")
	athlete.skeleton = $Athlete/Armature/Skeleton
	ideal.skeleton = $Ideal/Armature/Skeleton
	set_default_root()
	set_default_pose(athlete)
	set_default_pose(ideal)
	pass

func update_data(data):
	update_athlete(data.athlete)
	update_ideal()
	pass

func update_ideal():
	var root = (PI*((IDEAL_TOTAL_STEPS/2)-1))/(IDEAL_TOTAL_STEPS*2)
	var transform = ideal.bases[ROOT]
	if(ideal_step < IDEAL_TOTAL_STEPS/2):
		root = (PI*ideal_step)/(IDEAL_TOTAL_STEPS*2)
	transform = transform.rotated(X, root)
	transform = transform.translated(Vector3(0, 0.39*ideal_step, -0.1*ideal_step))
	ideal.skeleton.set_bone_pose(ROOT, transform)

	if(ideal_step < IDEAL_TOTAL_STEPS/2):
		transform = ideal.bases[HEAD]
		transform = transform.rotated(X, (PI*IDEAL_TOTAL_STEPS)/(IDEAL_TOTAL_STEPS*4))
		ideal.skeleton.set_bone_pose(HEAD, transform)

		transform = ideal.bases[ARM_LL]
		transform = transform.rotated(Z, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*0.7))
		transform = transform.rotated(Y, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*0.4))
		transform = transform.rotated(X, (-PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.6))
		ideal.skeleton.set_bone_pose(ARM_LL, transform)

		transform = ideal.bases[ARM_UL]
		transform = transform.rotated(Y, (-PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.1))
		transform = transform.rotated(Z, (-PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.5))
		ideal.skeleton.set_bone_pose(ARM_UL, transform)

		transform = ideal.bases[ARM_LR]
		transform = transform.rotated(Z, (-PI*ideal_step)/(IDEAL_TOTAL_STEPS*0.7))
		transform = transform.rotated(Y, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*0.4))
		transform = transform.rotated(X, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.6))
		ideal.skeleton.set_bone_pose(ARM_LR, transform)

		transform = ideal.bases[ARM_UR]
		transform = transform.rotated(Y, (-PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.1))
		transform = transform.rotated(Z, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.5))
		ideal.skeleton.set_bone_pose(ARM_UR, transform)

	transform = ideal.bases[FOOT_L]
	transform = transform.rotated(X, ((PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.5))-root)
	ideal.skeleton.set_bone_pose(FOOT_L, transform)

	transform = ideal.bases[FOOT_R]
	transform = transform.rotated(X, ((PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.5))-root)
	ideal.skeleton.set_bone_pose(FOOT_R, transform)

	transform = ideal.bases[LEG_UL]
	transform = transform.rotated(Y, ((-PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.7))-root)
	ideal.skeleton.set_bone_pose(LEG_UL, transform)

	transform = ideal.bases[LEG_LL]
	transform = transform.rotated(Y, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.2))
	ideal.skeleton.set_bone_pose(LEG_LL, transform)

	transform = ideal.bases[LEG_UR]
	transform = transform.rotated(Y, ((-PI*ideal_step)/(IDEAL_TOTAL_STEPS*2.7))-root)
	ideal.skeleton.set_bone_pose(LEG_UR, transform)

	transform = ideal.bases[LEG_LR]
	transform = transform.rotated(Y, (PI*ideal_step)/(IDEAL_TOTAL_STEPS*1.2))
	ideal.skeleton.set_bone_pose(LEG_LR, transform)

	update_step()
	pass

func update_step():
	if ideal_step == 0:
		step_increasing = true
	elif ideal_step == IDEAL_TOTAL_STEPS-1:
		step_increasing = false

	if step_increasing:
		ideal_step += 1
	else:
		ideal_step -= 1
	pass

func update_athlete(bones):
	rotate_all(athlete, LEG_UL, bones.legs.ul)
	rotate_all(athlete, LEG_LL, bones.legs.ll)
	rotate_all(athlete, LEG_UR, bones.legs.ur)
	rotate_all(athlete, LEG_LR, bones.legs.lr)
	pass

# Transforms

func rotate(body, bone, axis, phi):
	var transform = body.bases[bone]
	transform = transform.rotated(axis, phi)
	body.skeleton.set_bone_pose(bone, transform)

func rotate_all(body, bone, phis):
	var transform = body.bases[bone]
	transform = transform.rotated(X, phis[0])
	transform = transform.rotated(Y, phis[1])
	transform = transform.rotated(Z, phis[2])
	body.skeleton.set_bone_pose(bone, transform)
	pass

func translate(body, bone, delta):
	var transform = body.bases[bone]
	transform = transform.translated(Vector3(delta[0], delta[1], delta[2]))
	body.skeleton.set_bone_pose(bone, transform)
	pass

# Default

func set_default_root():
	var transform = athlete.skeleton.get_bone_pose(ROOT)
	transform = transform.rotated(X, -PI/4)
	athlete.skeleton.set_bone_pose(ROOT, transform)
	athlete.bases[ROOT] =  transform

	transform = ideal.skeleton.get_bone_pose(ROOT)
	transform = transform.rotated(X, -PI/4)
	ideal.skeleton.set_bone_pose(ROOT, transform)
	ideal.bases[ROOT] =  transform
	pass

func set_default_pose(body):
	var transform = body.skeleton.get_bone_pose(HEAD)
	transform = transform.rotated(X, -PI/4)
	body.skeleton.set_bone_pose(HEAD, transform)
	body.bases[HEAD] = transform

	transform = body.skeleton.get_bone_pose(ARM_UL)
	transform = transform.rotated(X, PI/6)
	body.skeleton.set_bone_pose(ARM_UL, transform)
	body.bases[ARM_UL] = transform

	transform = body.skeleton.get_bone_pose(ARM_LL)
	transform = transform.rotated(X, PI/4)
	transform = transform.rotated(Y, -PI)
	transform = transform.rotated(Z, -PI/1.5)
	body.skeleton.set_bone_pose(ARM_LL, transform)
	body.bases[ARM_LL] = transform

	for id in range(8, 16):
		transform = body.skeleton.get_bone_pose(id)
		transform = transform.rotated(X, -PI/3)
		body.skeleton.set_bone_pose(id, transform)
		body.bases[id] = transform

	transform = body.skeleton.get_bone_pose(ARM_UR)
	transform = transform.rotated(X, -PI/6)
	body.skeleton.set_bone_pose(ARM_UR, transform)
	body.bases[ARM_UR] = transform

	transform = body.skeleton.get_bone_pose(ARM_LR)
	transform = transform.rotated(X, -PI/4)
	transform = transform.rotated(Y, -PI)
	transform = transform.rotated(Z, PI/1.5)
	body.skeleton.set_bone_pose(ARM_LR, transform)
	body.bases[ARM_LR] = transform

	for id in range(21, 29):
		transform = body.skeleton.get_bone_pose(id)
		transform = transform.rotated(X, PI/3)
		body.skeleton.set_bone_pose(id, transform)
		body.bases[id] = transform

	transform = body.skeleton.get_bone_pose(LEG_UL)
	transform = transform.rotated(Y, -PI/4)
	body.skeleton.set_bone_pose(LEG_UL, transform)
	body.bases[LEG_UL] = transform

	body.bases[LEG_LL] = body.skeleton.get_bone_pose(LEG_LL)
	body.bases[FOOT_L] = body.skeleton.get_bone_pose(FOOT_L)

	transform = body.skeleton.get_bone_pose(LEG_UR)
	transform = transform.rotated(Y, -PI/4)
	body.skeleton.set_bone_pose(LEG_UR, transform)
	body.bases[LEG_UR] = transform

	body.bases[LEG_LR] = body.skeleton.get_bone_pose(LEG_LR)
	body.bases[FOOT_R] = body.skeleton.get_bone_pose(FOOT_R)
	pass
