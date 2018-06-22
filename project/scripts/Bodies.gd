extends Node

class SpeedData:
	var summit = false
	var base = false
	var start_time = 0
	var current = 0

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

var speed_data = SpeedData.new()

var current_state = -1

func _ready():
	print("[INFO] Bodies: ready")
	set_athlete_frame(0.1)
	pass

func update_data(data):
	if data.state != current_state:
		current_state = data.state
		update_ideal_animation(data)
	update_athlete(data)
	return speed_data.current

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
		var value = data.ul[0]
		if value < 0.0 or value > 5.0:
			value = 0.1
		elif value > 1.0:
			value = 0.9
		var frame = value*2.5
		set_athlete_frame(frame)

		# We should not do anything on the X axis
		var transform = athlete_skeleton.get_bone_pose(LEG_UL)
		transform = transform.rotated(Z, -data.ul[1])
		transform = transform.rotated(Y, -data.ul[0])
		athlete_skeleton.set_bone_pose(LEG_UL, transform)

		# We should not do anything on the X axis
		transform = athlete_skeleton.get_bone_pose(LEG_UR)
		transform = transform.rotated(Z, -data.ul[1])
		transform = transform.rotated(Y, -data.ul[0])
		athlete_skeleton.set_bone_pose(LEG_UR, transform)

		# We should not do anything on the X axis
		transform = athlete_skeleton.get_bone_pose(LEG_LL)
		transform = transform.rotated(Z, -data.ul[1])
		if data.ul[0] < 0.0 or data.ul[0] > 5.0:
			transform = transform.rotated(Y, -data.ul[0])
		else:
			transform = transform.rotated(Y, data.ul[0]*2)
		athlete_skeleton.set_bone_pose(LEG_LL, transform)
		
		# We should not do anything on the X axis
		transform = athlete_skeleton.get_bone_pose(LEG_LR)
		transform = transform.rotated(Z, -data.ul[1])
		if data.ul[0] < 0.0 or data.ul[0] > 5.0:
			transform = transform.rotated(Y, -data.ul[0])
		else:
			transform = transform.rotated(Y, data.ul[0]*2)
		athlete_skeleton.set_bone_pose(LEG_LR, transform)

		calculate_speed(data.ul[0], OS.get_ticks_msec())
	pass

func set_athlete_frame(seconds):
	athlete_animation.play("ArmatureAction")
	athlete_animation.seek(seconds, true)
	athlete_animation.stop()
	pass

func calculate_speed(y, ms):
	if not speed_data.base and y < 0.1:
		speed_data.base = true
		if speed_data.summit:
			speed_data.base = false
			speed_data.summit = false
			speed_data.current = int(60000/(ms - speed_data.start_time))
		else:
			speed_data.start_time = ms
	elif not speed_data.summit and speed_data.base and y > 0.9 and y < 5.0:
		speed_data.summit = true
		speed_data.base = false
	pass

func _on_Ideal_animation_finished(animation):
	ideal_animation.play(animation)
	pass
