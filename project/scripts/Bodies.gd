extends Node

const LEG_UL = 29
const LEG_LL = 30

const LEG_UR = 32
const LEG_LR = 33

const X = Vector3(1.0, 0.0, 0.0)
const Y = Vector3(0.0, 1.0, 0.0)
const Z = Vector3(0.0, 0.0, 1.0)

onready var athlete_skeleton = $Athlete/Armature/Skeleton
onready var athlete_animation = $Athlete/AnimationPlayer

onready var ideal_skeleton = $Ideal/Armature/Skeleton
onready var ideal_animation = $Ideal/AnimationPlayer

var current_state = -1

var ul_default = null
var ll_default = null
var ur_default = null
var lr_default = null

var previous_ul_y = 0.0

func _ready():
	print("[INFO] Bodies: ready")
	set_athlete_frame(0.1)
	pass

func update_data(data):
	if data.state != current_state:
		current_state = data.state
		update_ideal_animation(data)
	update_athlete(data)
	pass

func update_ideal_animation(data):
	if current_state == data.NO_RESPONSE:
		ideal_animation.play("Salute")
	else:
		ideal_animation.play("ArmatureAction")
		if current_state == data.WAITING:
			ideal_animation.seek(0.1, true)
			ideal_animation.stop()
	pass

func update_athlete(data):
	if data.state == data.IN_ACTIVITY:
		var frame = data.ul[0]*2.5
		if previous_ul_y > data.ul[0]:
			frame = 5.0 - frame
		previous_ul_y = data.ul[0]
		set_athlete_frame(frame)

		if not ul_default:
			ul_default = athlete_skeleton.get_bone_pose(LEG_UL)

		# We should not do anything on the X axis
		var transform = ul_default
		transform = transform.rotated(Z, -data.ul[1])
		transform = transform.rotated(Y, -data.ul[0])
		athlete_skeleton.set_bone_pose(LEG_UL, transform)

		if not ur_default:
			ur_default = athlete_skeleton.get_bone_pose(LEG_UR)

		# We should not do anything on the X axis
		transform = ur_default
		transform = transform.rotated(Z, -data.ul[1])
		transform = transform.rotated(Y, -data.ul[0])
		athlete_skeleton.set_bone_pose(LEG_UR, transform)

		if not ll_default:
			ll_default = athlete_skeleton.get_bone_pose(LEG_LL)

		# We should not do anything on the X axis
		transform = ll_default
		transform = transform.rotated(Z, -data.ll[1])
		transform = transform.rotated(Y, -data.ll[0])
		athlete_skeleton.set_bone_pose(LEG_LL, transform)

		if not lr_default:
			lr_default = athlete_skeleton.get_bone_pose(LEG_LR)

		# We should not do anything on the X axis
		transform = lr_default
		transform = transform.rotated(Z, -data.ll[1])
		transform = transform.rotated(Y, -data.ll[0])
		athlete_skeleton.set_bone_pose(LEG_LR, transform)
	pass

func set_athlete_frame(seconds):
	athlete_animation.play("default")
	athlete_animation.seek(seconds, true)
	athlete_animation.stop()
	pass

func _on_Ideal_animation_finished(animation):
	ideal_animation.play(animation)
	pass
