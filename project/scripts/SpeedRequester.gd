extends HTTPRequest

const ENDPOINT = "speed"

var url = ""
var has_url = false

func _ready():
	print("[INFO] SpeedRequester: ready")
	pass

func has_url():
	return has_url

func set_url(hostname):
	url = hostname + ENDPOINT
	has_url = true
	print("[INFO] SpeedRequester: got url " + url)
	pass

func perform_request():
	if(has_url):
		request(url)
	else:
		print("[ERROR] SpeedRequester: Empty URL")
	pass
