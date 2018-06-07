extends HTTPRequest

var url = ""
var has_url = false

func _ready():
	print("[INFO] QRCodeRequester: ready")
	pass

func has_url():
	return has_url

func set_url(path):
	url = path
	has_url = true
	print("[INFO] QRCodeRequester: got url " + url)
	pass

func perform_request():
	if(has_url):
		request(url)
		set_download_file("res://resources/qrcode.png")
	else:
		print("[ERROR] QRCodeRequester: Empty URL")
	pass