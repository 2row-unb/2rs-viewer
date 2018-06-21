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

func _ready():
	print("[INFO] Bodies: ready")
	athlete_animation.play("default")
	athlete_animation.seek(0.1, true)
	athlete_animation.stop()
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
		#print(abs(ideal_skeleton.get_bone_pose(LEG_UL)[0][0])*100)		
		#athlete_animation.seek(abs(data.ul[0]), true)
		if not ul_default:
			var default = athlete_skeleton.get_bone_pose(LEG_UL)
			ul_default = default
		var transform = ul_default
		transform = transform.rotated(X, data.ul[0])
		transform = transform.rotated(Y, data.ul[1])
		transform = transform.rotated(Z, data.ul[2])
		athlete_skeleton.set_bone_pose(LEG_UL, transform)

func _on_Ideal_animation_finished(animation):
	ideal_animation.play(animation)
	pass