class_name PlayTransfer

# 等待初始的两行
func wait_init_lines(play_id: String):
	var dict = {
		playId = play_id,
		column = 9
	}
	NetManage.require(TransferType.TYPE_PLAY_INIT_LINES,JSON.stringify(dict))

# 等待初始的两行
func wait_next_line(play_id: String,line: int):
	var dict = {
		playId = play_id,
		index = line,
		column = 9
	}
	var dictStr = JSON.stringify(dict)
	NetManage.require(TransferType.TYPE_PLAY_NEXT_LINE,dictStr)


# 等待初始的两行
func wait_next_event(play_id: String,line: int):
	var dict = {
		playId = play_id,
		index = line,
		column = 9
	}
	var dictStr = JSON.stringify(dict)
	NetManage.require(TransferType.TYPE_PLAY_EVENT,dictStr)

func update_score(play_id: String, user_id: String, score: int):
	var dict = {
		playId = play_id,
		userId = user_id,
		score = score
	}
	var dictStr = JSON.stringify(dict)
	NetManage.require(TransferType.TYPE_PLAY_UPDATE_SCORE,dictStr)
	
func got_line(play_id: String,index: int):
	var dict = {
		playId = play_id,
		index = index,
		column = 9
	}
	var dictStr = JSON.stringify(dict)
	NetManage.require(TransferType.TYPE_PLAY_GOT_LINE,dictStr)

func got_event(play_id: String,index: int):
	var dict = {
		playId = play_id,
		index = index,
		column = 9
	}
	var dictStr = JSON.stringify(dict)
	NetManage.require(TransferType.TYPE_PLAY_GOT_EVENT,dictStr)
