extends Node

onready var power = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/PowerContainer/Power
onready var speed = $MarginContainer/VerticalContainer/StatusContainer/LeftContainer/SpeedContainer/Speed
onready var minutes = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Minutes
onready var seconds = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/TimerContainer/TimerData/Seconds
onready var more = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/More
onready var difficulty = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Difficulty
onready var less = $MarginContainer/VerticalContainer/StatusContainer/RightContainer/DifficultyContainer/DifficultyData/Less

onready var status_container = $MarginContainer/VerticalContainer/StatusContainer
onready var message_container = $MarginContainer/VerticalContainer/MessageContainer

onready var athlete_label = $MarginContainer/VerticalContainer/MotionContainer/AthleteContainer/AthleteLabel
onready var logo = $MarginContainer/VerticalContainer/MotionContainer/AthleteContainer/Logo
onready var athlete_viewport = $MarginContainer/VerticalContainer/MotionContainer/AthleteContainer/Container

onready var ideal_label = $MarginContainer/VerticalContainer/MotionContainer/IdealContainer/IdealLabel

onready var message = $MarginContainer/VerticalContainer/MessageContainer/Message

var current_state = -1

func _ready():
	print("[INFO] Hud: ready")
	pass

func update_data(data):
	if current_state != data.state:
		current_state = data.state
		if current_state == data.NO_RESPONSE:
			status_container.hide()
			athlete_label.hide()
			athlete_viewport.hide()
			logo.show()
			message_container.show()
			ideal_label.text = "Diga OLÁ ao Rowbô!"
			message.text = "Aguardando Inicialização do Sistema"
		elif current_state == data.WAITING:
			status_container.hide()
			athlete_label.hide()
			athlete_viewport.hide()
			logo.show()
			message_container.show()
			ideal_label.text = "Posição para Calibração"
			message.text = "Por favor, calibre o 2RSuit"
		else:
			message_container.hide()
			logo.hide()
			status_container.show()
			athlete_label.show()
			athlete_viewport.show()
			ideal_label.text = "Exercício Esperado"
			athlete_label.text = "Seu Exercício"

	if current_state == data.IN_ACTIVITY:
		update_status(data)
	pass

func update_status(data):
	power.text = str(data.power)
	speed.text = str(data.speed)

	minutes.text = "%02d" % data.timer_minutes
	seconds.text = "%02d" % data.timer_seconds

	difficulty.text = str(data.difficulty)

	if data.difficulty < 1:
		less.text = ""
		more.text = ">"
	elif data.difficulty < 3:
		less.text = "<"
		more.text = ">"
	else:
		less.text = "<"
		more.text = ""
	pass
