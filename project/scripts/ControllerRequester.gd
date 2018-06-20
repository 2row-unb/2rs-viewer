extends Node

const NO_RESPONSE = 0
const WAITING = 1
const IN_ACTIVITY = 2
const AFTER_ACTIVITY = 3

class Athlete:
	var l_thigh_1 = [ 0.0, 0.0, 0.0 ]

class Dataset:
	var athlete = Athlete.new()
	var state = 0
	var performance = 0
	var power = 0
	var speed = 0
	var timer_minutes = 0
	var timer_seconds = 0
	var has_higher_difficulty = false
	var difficulty = 0
	var has_lesser_difficulty = false
	var has_qrcode = false
	var errors = Array()

const URL = "http://192.168.25.86:5000/"
# const URL = "http://localhost:20000/"

var data = Dataset.new()

func _ready():
	print("[INFO] ControllerRequester: ready")
	$AnglesRequester.set_url(URL)
	pass

func get_current_data():
	return data

func clear_errors():
	data.errors.clear()
	pass

func extract_angles(result):
	if result.status == "ok":
		data.athlete.l_thigh_1[0] = result.athlete.l_thigh_1[0]
		data.athlete.l_thigh_1[1] = result.athlete.l_thigh_1[1]
		data.athlete.l_thigh_1[2] = result.athlete.l_thigh_1[2]
		data.difficulty = result.difficulty
		data.power = result.power
		data.speed = result.speed
		data.state = result.state
		data.timer_minutes = int(result.timer) / 60
		data.timer_seconds = int(result.timer) % 60
	else:
		data.state = NO_RESPONSE
		for error in result.errors:
			data.errors.push_back(error)
	pass

func _on_RequestTimer_timeout():
	$AnglesRequester.perform_request()
	pass

func _on_AnglesRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_angles(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Não foi possível sincronizar os dados."
		data.errors.push_back(error)
		print("[ERROR] ControllerREquester: Couldn't get 2RS-Controller Angles")
	pass
