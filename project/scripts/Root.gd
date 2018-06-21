extends Node

func _ready():
	print("[INFO] Root: ready")
	pass

func _process(delta):
	$ViewerScreen.update_data($ControllerRequester.get_current_data())
	pass
