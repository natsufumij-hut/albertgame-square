class_name  Successed
extends NinePatchRect

signal next_level

@onready var anim := $AnimationPlayer as AnimationPlayer

func go_next_level():
	next_level.emit()
	visible = false

func go_title():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

func show_this():
	anim.play("anim")

func _on_next_pressed():
	anim.play("close")
