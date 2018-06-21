extends Node

func _ready():
	print("[INFO] Root: ready")
	pass

func _process(delta):
	var data = $ServerRequester.get_current_data()
	$Bodies.update_data(data)
	$Hud.update_data(data)
	pass
