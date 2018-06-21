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

var ul_default = null

func _ready():
	print("[INFO] Bodies: ready")
	athlete_animation.play("default")
	pass

func update_data(data):
	print(data.ul)
	athlete_animation.stop(true)
	if not ul_default:
		var default = athlete_skeleton.get_bone_pose(LEG_UL)
		ul_default = default
	var transform = ul_default
	transform = transform.rotated(X, data.ul[0])
	transform = transform.rotated(Y, data.ul[1])
	transform = transform.rotated(Z, data.ul[2])
	athlete_skeleton.set_bone_pose(LEG_UL, transform)
	pass

func _on_Ideal_animation_finished(animation):
	ideal_animation.play(animation)
	pass
