extends HTTPRequest

const ENDPOINT = "info"

var url = ""
var has_url = false

func _ready():
	print("[INFO] InfoEndpoint: ready")
	pass

func has_url():
	return has_url

func set_url(hostname):
	url = hostname + ENDPOINT
	has_url = true
	print("[INFO] InfoEndpoint: got url " + url)
	pass

func perform_request():
	if(has_url):
		request(url)
	else:
		print("[ERROR] InfoEndpoint: Empty URL")
	pass
