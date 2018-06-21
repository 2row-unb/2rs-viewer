extends Node

class Dataset:
	var ul = [0.0, 0.0, 0.0]
	var ll = [0.0, 0.0, 0.0]
	var state = 0
	var power = 0
	var speed = 0
	var timer_minutes = 0
	var timer_seconds = 0
	var difficulty = 0
	var errors = Array()
	const NO_RESPONSE = 0
	const WAITING = 1
	const IN_ACTIVITY = 2

# const URL = "http://localhost:5000/"
const URL = "http://192.168.25.86:5000/"
# const URL = "http://localhost:20000/"

var data = Dataset.new()

func _ready():
	print("[INFO] ServerRequester: ready")
	$InfoEndpoint.set_url(URL)
	pass

func get_current_data():
	return data

func clear_errors():
	data.errors.clear()
	pass

func extract_info(result):
	if result.has("state"):
		if result.state == data.IN_ACTIVITY:
			data.ul = result.ul
			data.ll = result.ll
			data.difficulty = result.difficulty
			data.power = result.power
			data.speed = result.speed
			data.state = result.state
			data.timer_minutes = int(result.timer) / 60
			data.timer_seconds = int(result.timer) % 60
		elif result.state == data.WAITING:
			data.state = data.WAITING
		else:
			data.state = data.NO_RESPONSE
	else:
		data.state = data.NO_RESPONSE
	pass

func _on_RequestTimer_timeout():
	$InfoEndpoint.perform_request()
	pass

func _on_InfoEndpoint_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_info(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Não foi possível sincronizar os dados."
		data.errors.push_back(error)
	pass
