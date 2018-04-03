extends HTTPRequest

const ENDPOINT = "heartbeat"

var url = ""
var has_url = false

func _ready():
	print("[INFO] HeartbeatRequester: ready")
	pass

func has_url():
	return has_url

func set_url(hostname):
	url = hostname + ENDPOINT
	has_url = true
	print("[INFO] HeartbeatRequester: got url " + url)
	pass

func perform_request():
	if(has_url):
		request(url)
	else:
		print("[ERROR] HeartbeatRequester: Empty URL")
	pass