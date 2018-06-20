extends Node

const SCENES = [
	"",
	"res://screens/SplashScreen.tscn",
	"res://screens/ViewerScreen.tscn",
	"res://screens/ResultScreen.tscn"
]

var scene = null
var current_state = 0

func _ready():
	print("[INFO] Root: ready")
	var root = get_tree().get_root().get_child(0)
	scene = root.get_child(root.get_child_count()-1)
	pass

func _process(delta):
	var data = $ControllerRequester.get_current_data()
	if(data.state != $ControllerRequester.NO_RESPONSE):
		if(current_state != data.state):
			current_state = data.state
			update_scene()
	else:
		if(current_state != $ControllerRequester.WAITING):
			current_state = $ControllerRequester.WAITING
			update_scene()
			print("[ERROR] Root: No response from the server. Performing attempts without logging it.")
	handle_current_scene(data)
	pass

func update_scene():
	print("[INFO] Root: Changing Scene")
	scene.queue_free()
	var new_scene = ResourceLoader.load(SCENES[current_state])
	scene = new_scene.instance()
	get_tree().get_root().get_child(0).add_child(scene)
	pass

func handle_current_scene(data):
	if(scene.has_method("update_data")):
		scene.update_data(data)
	pass
