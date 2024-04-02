extends Node2D

var tools: = CraksTool.new()
@onready var score :Score = $StoryHUD/Score
@onready var grid: GameGrid = $StoryHUD/GameGrid
@onready var diedPanel: Died = $StoryHUD/Died

@export var max_level: int = 10
var index = 0

const events = [ "SnowEvent", "IceEvent" ]

func _ready():
	#var loader = LoadLevel.new()
	#lines = loader.load_level(now_level)
	grid.start_grid()
	GlobalSignal.add_score.connect(self.add_score)
	set_max_score(GameDataLoader.localData.unlimit_max)

func set_max_score(sc: int):
	var text := $StoryHUD/MaxScore
	text.text = "MAX： "+String.num(sc)

func update_score(sc: int):
	if sc > GameDataLoader.localData.unlimit_max:
		set_max_score(sc)

func wait_init_lines():
	#var line0 = lines[index].line
	#var line1 = lines[index+1].line
	#index+=2
	var line0 = tools.generate_line_data(9)
	var line1 = tools.generate_line_data(9)
	grid.put_init_lines(line0,line1)

func wait_next_line():
	#if index==lines.size():
		#print("关卡结束!!!!")
		#grid.no_more_line()
	#else:
		#var line0 = lines[index].line
		#index+=1
		##var line0 = tools.generate_line_data(9)
		#grid.put_new_line(line0)
	var line0 = tools.generate_line_data(9)
	grid.put_new_line(line0)

func wait_next_event():
	var r = randi() % 100
	if r<10:
		r = r % events.size()
		var id = events[r]
		show_event(id)
	else:
		grid.event_end()
	#print("查找事件!!!")
	#grid.event_end()
	#var line = lines[index]
	#if line.type==LevelLine.TYPE_EVENT:
		#if line.event==LevelLine.EVENT_SNOW:
			#event_show()
		#index+=1
	#else:
		#print("没有事件!!!")
		#grid.event_end()

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
	#grid.event_end()

func go_titled():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")


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

# 重玩这个关卡
func replay():
	grid.restart()

func _on_bask_item_click():
	if GameDataLoader.consumer_tai(5):		
		var bask := $StoryHUD/Items/Grid/Bask as ItemScript
		bask.start_item(grid.grid,$StoryHUD/GameGrid/Craks)

func _on_item_end():
	grid.wait_end()
