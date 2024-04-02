# 彩蛋处理器
class_name EasterEggHandle

signal egg_end
signal play_end(egg_script: EggScript)

# 1.遍历方块，查找适合的彩蛋
# 2.按顺序播放彩蛋动画
# 3.彩蛋结束
var egg: Array[String] = []
var egg_index = 0
var craks: Control

const egg_scene_pref = "res://nodes/egg/"

var egg_checks = {
	"WhatAreYouDoing": WhatAreYouDoingEggCheck.new()
}

func handle_easter_egg(clearData: Array[Vector2i],cracks: Control):
	egg.clear()
	egg_index=0
	self.craks=cracks
	var tools := CraksTool.new()
	var arr: Array[CrackScript] = []
	for cl in clearData:
		var item = tools.get_cell(cracks,cl.x,cl.y) as CrackScript
		if item!=null:
			arr.append(item)
	if arr.is_empty():
		handle_easter_egg_end()
	else:
		for name in egg_checks:
			var check: = egg_checks[name] as EggCheck
			if check.check(arr):
				egg.append(name)		
		next_egg()

func next_egg():
	if egg_index>=egg.size():
		handle_easter_egg_end()
		return
	var path = egg_scene_pref + egg[egg_index] + ".tscn"
	var packed := load(path) as PackedScene
	var egg_script := packed.instantiate() as EggScript
	egg_script.egg_end.connect(self.next_egg)
	play_end.emit(egg_script)
	craks.add_child(egg_script)
	egg_script.start_egg()
	egg_index+=1

func handle_easter_egg_end():
	egg_end.emit()
	
