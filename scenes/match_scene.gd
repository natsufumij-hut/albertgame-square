extends Control

@onready var users := $NinePatchRect as Control
@export var textures: Array[Texture2D] = []

var room_transfer := RoomTransfer.new()
var room_id := "" as String

# Called when the node enters the scene tree for the first time.
func _ready():
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_ROOM_CREATE,self.create_room_response)
	NetManage.add_handler(TransferData.MODEL_REQUIRE,TransferType.TYPE_ROOM_INVITE_ME,self.invite_me)
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_ROOM_INVITE_CONFIRM,self.invite_result)
	NetManage.add_handler(TransferData.MODEL_REQUIRE,TransferType.TYPE_ROOM_REFRESH,self.room_refresh)
	set_is_master(true)
	create_room()

func refresh_user(i: int, type: int, user_name: String):
	var path = "Userinfo"+String.num(i+1)
	var user_info := users.get_node(path) as UserInfo
	if user_info!=null:
		var text = textures[type]
		user_info.refresh_data(text,user_name)

# 设置是否是master
func set_is_master(is_master: bool):
	var group = get_tree().get_nodes_in_group("closeUser")
	for node in group:
		node.visible = is_master
	$Quit.visible = !is_master
	$Start.visible = is_master

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

func _on_quit_pressed():
	pass # Replace with function body.

func _on_start_pressed():
	pass # Replace with function body.

func _on_invite_pressed():
	$CanvasLayer/Invite.visible = true

func create_room():
	room_transfer.create_room()

func invite_room(user_id: String):
	room_transfer.invite_someone(user_id,room_id)

# 处理传来的房间信息
# response:
# CREATE_ROOM,body: {room_id}
# INVITE_ME,body: {room_id}
# QUIT_ROOM,body: {user_id}
func create_room_response(data: TransferData):
	var uuid = data.body
	self.room_id = uuid
	print("create room successfully, ",uuid)

func invite_me(data: TransferData):
	var dict :Dictionary = JSON.parse_string(data.body)
	print(dict['one_id']," invite me ,room id,",dict['room_id'])
	var invite_me := $CanvasLayer/InviteMe as InviteMe
	invite_me.refresh_info(dict['one_id'],dict['room_id'])
	invite_me.visible = true

# INVITE_CONFIRM,body: {user_id,is_ok}
func invite_result(data: TransferData):
	var dict: Dictionary = JSON.parse_string(data.body)
	var user_id = dict['user_id'] as String
	var is_ok = dict['confirm'] as bool
	print("invite_result ",user_id," is_ok? ",is_ok)

# QUIT_ROOM,body: {user_id}
func somebody_quit_room(data: TransferData):
	var dict := JSON.parse_string(data.body) as Dictionary
	var user_id = dict['userId']
	print('userId,',user_id,' quit.')

# PERSON_REFRESH,body: {room_id,master_id,[{user_id,user_type}]}
func room_refresh(data: TransferData):
	print("room_refresh")
	var dict = JSON.parse_string(data.body)
	var p_room_id = dict['roomId']
	var master_id = dict['masterId']
	var arr = dict['members'] as Array
	room_id=p_room_id
	set_is_master(master_id==NetManage.get_user_id())
	set_members(arr)

func set_members(arr: Array):
	for i in range(0,arr.size()):
		var item = arr[i] as Dictionary
		var user_id = item['userId'] as String
		var user_type = item['type'] as int
		refresh_user(i,user_type,user_id)
	if arr.size()<5:
		for i in range(arr.size(),6):
			refresh_user(i,0,"no")
