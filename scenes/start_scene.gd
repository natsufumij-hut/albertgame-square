extends Node2D

@export var logined_texture: Texture2D

func _ready():
	check_logined()

func _on_story_button_pressed():
	get_tree().change_scene_to_file("res://scenes/story_game.tscn")

func _on_un_limit_pressed():
	get_tree().change_scene_to_file("res://scenes/unline_game.tscn")

func check_logined():
	print("she")
	if NetManage.is_logined():
		$StartHUD/Login.texture_normal = logined_texture

func _on_login_pressed():
	get_tree().change_scene_to_file("res://scenes/login.tscn")

func _on_link_pressed():
	get_tree().change_scene_to_file("res://scenes/match_scene.tscn")
