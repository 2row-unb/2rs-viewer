extends Node

func _ready():
	print("[INFO] Root: ready")
	pass

func _process(delta):
	$Athlete.update_data($ControllerRequester.get_current_data())
	pass
