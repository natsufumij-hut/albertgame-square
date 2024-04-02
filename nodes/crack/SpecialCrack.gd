class_name SpecialCrack
extends CrackScript

# 特殊结束时的回调
signal this_special_end

var extra: Array[Vector2i]

@onready var anim := $AnimationPlayer as AnimationPlayer

func start_special(grid: Array2D,source: Array[Vector2i], cracks: Control,now_pos: Vector2i):
	extra = special_calc_for_extra(grid,source,cracks,now_pos)
	special_call(grid,source,cracks,now_pos)
	anim.play("special")

func special_call(grid: Array2D,source: Array[Vector2i], cracks: Control,now_pos: Vector2i):
	pass

func special_calc_for_extra(grid: Array2D,source: Array[Vector2i], cracks: Control,now_pos: Vector2i)->Array[Vector2i]:
	return []
	
func end_special():
	print("special end")
	this_special_end.emit()
	print("")
