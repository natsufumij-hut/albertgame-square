extends Node2D

var tools: = CraksTool.new()
@onready var score :Score = $StoryHUD/Score
@onready var grid: GameGrid = $StoryHUD/GameGrid
@onready var levelLabel: Label = $StoryHUD/Level
@onready var diedPanel: Died = $StoryHUD/Died
@onready var clearPanel: Successed = $StoryHUD/ClearAll
@onready var sucPanel: Successed = $StoryHUD/Successed

@export var max_level: int = 2
var index = 0

var lines: Array[LevelLine] = []
var now_level: int = 1

func _ready():
	var loader = LoadLevel.new()
	lines = loader.load_level(now_level)
	grid.start_grid()
	GlobalSignal.add_score.connect(self.add_score)
	set_max_score(GameDataLoader.localData.max_score)
	
func set_max_score(sc: int):
	var text := $StoryHUD/MaxScore
	text.text = "MAX： "+String.num(sc)

func update_score(sc: int):
	if sc > GameDataLoader.localData.max_score:
		set_max_score(sc)

func wait_init_lines():
	var line0 = lines[index].line
	var line1 = lines[index+1].line
	index+=2
	#var line0 = tools.generate_line_data(9)
	#var line1 = tools.generate_line_data(9)
	grid.put_init_lines(line0,line1)

func wait_next_line():
	if index==lines.size():
		print("关卡结束!!!!")
		grid.no_more_line()
	else:
		var line0 = lines[index].line
		index+=1
		#var line0 = tools.generate_line_data(9)
		grid.put_new_line(line0)

func wait_next_event():
	print("查找事件!!!")
	var line = lines[index]
	if line.type==LevelLine.TYPE_EVENT:
		if line.event==LevelLine.EVENT_SNOW:
			event_show()
		index+=1
	else:
		print("没有事件!!!")
		grid.event_end()

func event_show():
	var pack := load("res://nodes/event/SnowEvent.tscn") as PackedScene
	var ind:  = pack.instantiate() as CrackEvent
	ind.craks = grid.get_node("Craks")
	ind.grid = grid.grid
	ind.event_end.connect(self.event_end)
	$StoryHUD.add_child(ind)
	add_child(ind)
	ind.start_crak_event()
	#grid.event_end()
	
func event_end():
	print("事件结束")
	grid.event_end()

func add_score(sc: int):
	var s = (sc * 10)
	score.add_score(s)

func failed():
	var sc = score.score
	diedPanel.did_score(sc)
	GameDataLoader.updateMaxScore(sc)

func successed():
	if now_level==max_level:
		clearPanel.show_this()
	else:
		sucPanel.show_this()

func go_next_level():
	start_level(now_level+1)

# 重玩这个关卡
func replay():
	start_level(now_level)

func go_titled():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

# 开始关卡X
func start_level(level: int):
	now_level = level
	GameDataLoader.updateMaxLevel(now_level)
	levelLabel.text = "level "+String.num(level)
	index=0
	var loader = LoadLevel.new()
	lines = loader.load_level(level)
	grid.restart()

func _on_bask_item_click():
	var bask := $StoryHUD/Items/Grid/Bask as ItemScript
	bask.start_item(grid.grid,$StoryHUD/GameGrid/Craks)
