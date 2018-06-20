extends Node

const NO_RESPONSE = 0
const WAITING = 1
const IN_ACTIVITY = 2
const AFTER_ACTIVITY = 3

class BodyMember:
	var ul = [0.0, 0.0, 0.0]
	var ll = [0.0, 0.0, 0.0]
	var ur = [0.0, 0.0, 0.0]
	var lr = [0.0, 0.0, 0.0]

class Body:
	var legs = BodyMember.new()
	var arms = BodyMember.new()
	var root = [0.0, 0.0, 0.0]

class Dataset:
	var athlete = Body.new()
	var ideal = Body.new()
	var state = 0
	var power = 0
	var speed = 0
	var timer_minutes = 0
	var timer_seconds = 0
	var difficulty = 0
	var errors = Array()

# const URL = "http://localhost:5000/"
# const URL = "http://192.168.25.86:5000/"
const URL = "http://localhost:20000/"

var data = Dataset.new()

func _ready():
	print("[INFO] ControllerRequester: ready")
	$InfoRequester.set_url(URL)
	pass

func get_current_data():
	return data

func clear_errors():
	data.errors.clear()
	pass

func extract_info(result):
	if result.state == IN_ACTIVITY:
		extract_athlete(result.athlete)
		data.difficulty = result.difficulty
		data.power = result.power
		data.speed = result.speed
		data.state = result.state
		data.timer_minutes = int(result.timer) / 60
		data.timer_seconds = int(result.timer) % 60
	elif result.state == WAITING:
		pass
	elif result.state == AFTER_ACTIVITY:
		pass
	else:
		data.state = NO_RESPONSE
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_athlete(athlete):
	if athlete != null:
		if athlete.legs:
			data.athlete.legs.ul = athlete.legs.ul
			data.athlete.legs.ll = athlete.legs.ll
			data.athlete.legs.ur = athlete.legs.ur
			data.athlete.legs.lr = athlete.legs.lr

		if athlete.arms:
			data.athlete.arms.ul = athlete.arms.ul
			data.athlete.arms.ll = athlete.arms.ll
			data.athlete.arms.ur = athlete.arms.ur
			data.athlete.arms.lr = athlete.arms.lr

		if athlete.root:
			data.athlete.root = athlete.root
	pass

func _on_RequestTimer_timeout():
	$InfoRequester.perform_request()
	pass

func _on_InfoRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_info(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Não foi possível sincronizar os dados."
		data.errors.push_back(error)
	pass
