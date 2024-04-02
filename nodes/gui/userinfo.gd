class_name UserInfo
extends Control

@onready var avatar := $Avatar as TextureRect
@onready var label: = $Label as Label

func refresh_data(texture: Texture2D, user_name: String):
	avatar.texture = texture
	label.text = user_name
