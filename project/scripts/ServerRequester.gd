extends Node

class Dataset:
	var ul = [0.0, 0.0, 0.0]
	var ll = [0.0, 0.0, 0.0]
	var state = 0
	var force = 0
	var speed = 0
	var timer = 0
	var difficulty = 0
	const NO_RESPONSE = 0
	const WAITING = 1
	const IN_ACTIVITY = 2

# const URL = "http://localhost:5000/"
const URL = "http://192.168.1.101:5000/"

var data = Dataset.new()
var mock = [0.0, 0.0, 0.0]
var mock_signal = 1

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
		data.state = result.state
		if result.state == data.IN_ACTIVITY:
			data.ul = result.ul
			# data.ll = result.ll
			data.difficulty = result.difficulty
			data.force = result.force
			data.timer = result.timer
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
		data.state = data.NO_RESPONSE
	pass
