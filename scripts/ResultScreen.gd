extends Container

onready var performance = $MarginContainer/VerticalContainer/TopContainer/PerformanceContainer/Performance
onready var qrcode_label = $MarginContainer/VerticalContainer/TopContainer/QRCodeContainer/QRCodeLabel
onready var qrcode = $MarginContainer/VerticalContainer/TopContainer/QRCodeContainer/QRCode
onready var power = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/PowerContainer/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/SpeedContainer/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Seconds
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/Difficulty

func _ready():
	print("[INFO] ResultScreen: ready")
	pass

func update_data(data):
	print("[INFO] ResultScreen: Updating data")
	
	performance.text = str(data.performance) + "%"

	power.text = str(data.power)
	speed.text = str(data.speed)

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	difficulty.text = str(data.difficulty)

func render_qrcode(data):
	if data.has_qrcode:
		qrcode_label.text = "Copiar Resultados"
		qrcode.set_texture(load("res://resources/qrcode.png"))