class_name GameGrid
extends NinePatchRect

signal wait_init_lines
signal wait_new_line
signal wait_event
signal add_score(score: int)
signal end
signal successed

@export var one: PackedScene
@export var two: PackedScene
@export var three: PackedScene

@onready var tree: =$AnimationTree as AnimationTree

var rows: int = 11
var columns: int = 9
var grid: Array2D = Array2D.new() #当前的数据
var init: InitCraks
var drop: DropCraks
var breaks: BreakCrak
var handle: HandleCrak
var tools: CraksTool = CraksTool.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var width = $Craks.size.x
	var height = $Craks.size.y
	var tileWidth = width / columns
	var tileHeight = height / rows
	init = InitCraks.new(columns,rows,$Craks,[one,two,three],grid,$AnimationTree)
	init.wait_init_lines.connect(self.wait_init)
	drop = DropCraks.new(columns,rows,$Craks,[one,two,three],grid,$AnimationTree)
	handle = HandleCrak.new(columns,rows,$Craks,[one,two,three],grid,$AnimationTree)
	handle.wait_next_line.connect(self.wait_next_line)
	handle.failed.connect(self.failed_call)
	breaks = BreakCrak.new(columns,rows,$Craks,[one,two,three],grid,$AnimationTree,$ExpireCrak)
	breaks.got_score.connect(self.got_score)

# 初始化方块格
func _init_grid():
	var arr = []
	grid.clear()
	for i in range(0,columns):
		arr.append(0)
	for i in range(0,rows):
		grid.insert_row(0,arr.duplicate(false))
	var craks := $Craks as Control
	var children = craks.get_children()
	for child in children:
		child.name=child.name+"xxxxx"
		child.visible = false
		child.queue_free()
		print("释放child",child.name)

func start_grid():
	tree.set("parameters/conditions/Start",true)

# 等待初始化
func wait_init():
	print("等待初始化!!!!")
	_init_grid()
	wait_init_lines.emit()

func restart():
	handle.reset()
	tree.set("parameters/conditions/Restart",true)

# 等待下一行
func wait_next_line():
	print("下一行!!!!")
	wait_new_line.emit()

# 等待事件
func wait_for_event():
	print("等待事件!")
	wait_event.emit()

func event_end():
	tree.set("parameters/Event/conditions/EventEnd",true)

func failed_call():	
	tree.set("parameters/conditions/Failed",true)
	end.emit()

# 初始两行方块格
func init_craks():
	#_TEST_test_crack_check()
	init.init_craks()

# 掉落
func drop_craks():
	drop.handle_drop()

# 拆方块	
func break_craks():
	breaks.break_crak()

# 等待处理
func wait_handle():
	handle.handle_crak()

# 等待结束
func wait_end():
	handle.handle_end()

# 放置初始块
func put_init_lines(line0: Array,line1: Array):
	init.set_generate_lines(line0,line1)
	init.init_craks()

# 放置新的一行
func put_new_line(line0: Array):
	handle.set_new_line(line0)
	handle.move_up()

func no_more_line():
	tree.set("parameters/conditions/Successed",true)
	successed.emit()

# 拆了几行
func got_score(sc: int):
	add_score.emit(sc)

func _input(event):
	handle._pri_handle_input(event,self)
