# 特殊效果处理器
class_name SpecialHandle

signal handle_end(extraData: Array[Vector2i])

var columns: int = 9
var rows: int = 11
var craks: Control
var grid: Array2D

var tools: = CraksTool.new()

var extras: Array[Vector2i] = []
var tween2: =TweenManage2.new()

func _init():
	tween2.all_end.connect(self.handle_all_end)

func handle_special(clearData: Array[Vector2i]):
	extras.clear()
	var arr: Array[Vector2i] = []
	for pos in clearData:
		var item := tools.get_cell(craks,pos.x,pos.y) as CrackScript
		if item.code==CrackScript.CODE_SPECIAL:
			if is_instance_of(item,SpecialCrack):
				arr.append(pos)
	var dict: Dictionary = {}
	for pos in arr:
		var item = tools.get_cell(craks,pos.x,pos.y) as SpecialCrack
		tween2.register(item.name)
		item.this_special_end.connect(self.tween_end.bind(item.name))
		if item.this_special_end.is_connected(self.tween_end):
			print("连接了connect")
		item.start_special(grid,clearData,craks,pos)
	if arr.is_empty():
		handle_all_end()

func end_one(extr: Array[Vector2i]):
	print("end_one")

func handle_all_end():
	print("handle_all_end")
	handle_end.emit(extras)

func tween_end(id: String):
	tween2.end(id)
