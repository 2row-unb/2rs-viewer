extends HTTPRequest

const ENDPOINT = "difficulty"

var url = ""
var has_url = false

func _ready():
	print("[INFO] DifficultyRequester: ready")
	pass

func has_url():
	return has_url

func set_url(hostname):
	url = hostname + ENDPOINT
	has_url = true
	print("[INFO] DifficultyRequester: got url " + url)
	pass

func perform_request():
	if(has_url):
		request(url)
	else:
		print("[ERROR] DifficultyRequester: Empty URL")
	pass
