class_name InviteMe
extends Control

var user_id :String = "No"
var room_id :String = "No"

var room := RoomTransfer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Closepanel/Label3.text = user_id

func refresh_info(user_id: String, room_id: String):
	self.user_id = user_id
	self.room_id = room_id
	$Closepanel/Label3.text = user_id

func _on_ok_pressed():
	room.invite_confirm(true,room_id,user_id)
	visible = false

func _on_closepanel_panel_close():
	room.invite_confirm(false,room_id,user_id)
	visible = false
