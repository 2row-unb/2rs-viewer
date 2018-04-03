extends Node

class Dataset:
	var is_running = false
	var heartbeat = 0
	var power = 0
	var speed = 0
	var timer_minutes = 0
	var timer_seconds = 0
	var has_higher_difficulty = false
	var difficulty = 0
	var has_lesser_difficulty = false
	var errors = Array()

const URL = "http://localhost:20000/"

var data = Dataset.new()

func _ready():
	print("[INFO] ControllerRequester: ready")
	$StatusRequester.set_url(URL)
	$HeartbeatRequester.set_url(URL)
	$PowerRequester.set_url(URL)
	$SpeedRequester.set_url(URL)
	$TimerRequester.set_url(URL)
	$DifficultyRequester.set_url(URL)
	pass

func get_current_data():
	return data

func clear_errors():
	data.errors.clear()
	pass

func request_status():
	$StatusRequester.perform_request()
	pass

func extract_status(result):
	if result.ok:
		data.is_running = true
		$HeartbeatRequester.perform_request()
		$PowerRequester.perform_request()
		$SpeedRequester.perform_request()
		$TimerRequester.perform_request()
		$DifficultyRequester.perform_request()
	else:
		data.is_running = false
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_heartbeat(result):
	if result.ok:
		data.heartbeat = result.heartbeat
	else:
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_power(result):
	if result.ok:
		data.power = result.power
	else:
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_speed(result):
	if result.ok:
		data.speed = result.speed
	else:
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_timer(result):
	if result.ok:
		data.timer_minutes = int(result.timer) / 60
		data.timer_seconds = int(result.timer) % 60
	else:
		for error in result.errors:
			data.errors.push_back(error)
	pass

func extract_difficulty(result):
	if result.ok:
		data.has_higher_difficulty = result.more
		data.difficulty = result.difficulty
		data.has_lesser_difficulty = result.less
	else:
		for error in result.errors:
			data.errors.push_back(error)
	pass

func _on_RequestTimer_timeout():
	request_status()
	pass

func _on_StatusRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_status(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Não foi possível sincronizar os dados."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get 2RS-Controller Status")
	pass

func _on_HeartbeatRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_heartbeat(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Há algum erro no sensor de batimentos cardíacos."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get heartbeat from 2RS-Controller")
	pass


func _on_PowerRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_power(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Há algum erro no sensor de potência."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get power from 2RS-Controller")
	pass


func _on_SpeedRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_speed(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Há algum erro no sensor de velocidade."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get speed from 2RS-Controller")
	pass


func _on_TimerRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_timer(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Há algum erro no timer."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get timer from 2RS-Controller")
	pass


func _on_DifficultyRequester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		extract_difficulty(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var error = "Há algum erro no controle de dificuldade."
		data.errors.push_back(error)
		print("[ERROR] ControllerRequester: Couldn't get difficulty from 2RS-Controller")
	pass
