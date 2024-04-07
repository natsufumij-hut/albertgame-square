extends Node2D

var tools: = CraksTool.new()
@onready var score :Score = $StoryHUD/Score
@onready var grid: GameGrid = $StoryHUD/GameGrid
@onready var diedPanel: Died = $StoryHUD/Died
@onready var ranks: = $StoryHUD/Ranks as Ranks

@export var max_level: int = 10
var index = 0

const events = [ "SnowEvent", "IceEvent" ]

var nowIndex = 0
var nowEvent = 0

var play_id : = ""
var play := PlayTransfer.new()
var load := LoadLevel.new()

func _ready():
	#var loader = LoadLevel.new()
	#lines = loader.load_level(now_level)
	load_play()
	grid.start_grid()
	GlobalSignal.add_score.connect(self.add_score)
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_PLAY_INIT_LINES,self.get_init_lines_data)
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_PLAY_NEXT_LINE,self.get_next_line_data)
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_PLAY_EVENT,self.get_next_event)
	NetManage.add_handler(TransferData.MODEL_REQUIRE,TransferType.TYPE_PLAY_UPDATE_SCORE,self.get_update_score)

func update_score(sc: int):
	if play_id!='':
		play.update_score(play_id,NetManage.user_id,sc)

func load_play():
	var play_data = NetManage.play_data
	play_id = play_data['playId']
	var members = play_data['members']
	ranks.init_users(members)

func wait_init_lines():
	play.wait_init_lines(play_id)

func get_init_lines_data(pack: TransferData):
	var dict = JSON.parse_string(pack.body)
	var line0 = dict['line0']
	var line1 = dict['line1']
	var line0_data = load.load_data(line0)
	var line1_data = load.load_data(line1)
	put_init_lines(line0_data,line0_data)

func put_init_lines(line0: Array,line1: Array):
	grid.put_init_lines(line0,line1)
	nowIndex+=2

func wait_next_lines():
	play.wait_next_line(play_id,nowIndex)

func get_next_line_data(pack: TransferData):
	var dict = JSON.parse_string(pack.body)
	var line0 = dict['line']
	var line0_data = load.load_data(line0)
	put_next_lines(line0_data)

func put_next_lines(line: Array):
	grid.put_new_line(line)
	nowIndex+=1

func wait_next_event():
	play.wait_next_event(play_id,nowEvent)

func get_next_event(pack: TransferData):
	var dict = JSON.parse_string(pack.body)
	var event = dict['event']
	if event=="none":
		grid.event_end()
	else:
		show_event(event)
	nowEvent+=1

func get_update_score(pack: TransferData):
	var dict = JSON.parse_string(pack.body)
	var userId := dict['userId'] as String
	var score := dict['score'] as int
	print("some one update score, [",userId,' ',score,']')
	ranks.update_one_score(userId,score)

func show_event(id: String):
	var path = "res://nodes/event/"+id+".tscn"
	var pack := load(path) as PackedScene
	var ind:  = pack.instantiate() as CrackEvent
	ind.craks = grid.get_node("Craks")
	ind.grid = grid.grid
	ind.event_end.connect(self.event_end)
	$StoryHUD.add_child(ind)
	add_child(ind)
	ind.start_crak_event()

func event_end():
	print("事件结束")
	grid.event_end()

func add_score(sc: int):
	var s = (sc * 10)
	score.add_score(s)

func failed():
	var sc = score.score
	diedPanel.did_score(sc)
	GameDataLoader.updateMaxUnLimitScore(sc)

func _on_pause_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/match_scene.tscn")
