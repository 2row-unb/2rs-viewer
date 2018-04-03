extends Node

func _ready():
	print("[INFO] Root: ready")
	pass

func _on_UpdateTimer_timeout():
	var data = $ControllerRequester.get_current_data()
	if(data.is_running):
		$ViewerScreen.update_data(data)
	else:
		print("[ERROR] Root: 2RS-Controller is not running")
	pass