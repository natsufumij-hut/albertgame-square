class_name Died
extends NinePatchRect

signal replay

@export var score: int = 100
@onready var scoreV: Label = $Control/ScoreValue
@onready var anim: = $AnimationPlayer as AnimationPlayer

func _ready():
	scoreV.text = String.num(score)

func did_score(sc: int):
	score = sc
	scoreV.text = String.num(sc)
	anim.play("flip")

func close():
	anim.play("close")

func restart():
	replay.emit()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")
