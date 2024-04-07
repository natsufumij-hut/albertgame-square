class_name RoomTransfer

# 创建房间
func create_room():
	NetManage.require(TransferType.TYPE_ROOM_CREATE,"",true)

# 邀请某人来房间
func invite_someone(one_id: String, room_id: String):
	var dict = {
		"one_id": one_id,
		"room_id": room_id
	}
	NetManage.require(TransferType.TYPE_ROOM_INVITE_PERSON,JSON.stringify(dict),true)

# 处理邀请
func invite_confirm(confirm: bool, room_id: String, user_id: String):
	var dict = {
		"room_id": room_id,
		"confirm": confirm,
		"user_id": user_id
	}
	print("invite_confirm ",confirm," room id ",room_id )
	NetManage.require(TransferType.TYPE_ROOM_INVITE_CONFIRM,JSON.stringify(dict),true)

# 房主发出开始游戏的信号
func room_play(room_id: String):
	var dict = {
		"roomId": room_id,
		"column": 9
	}
	NetManage.require(TransferType.TYPE_ROOM_START,JSON.stringify(dict),true)

