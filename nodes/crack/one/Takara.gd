extends SpecialCrack

enum {
	SPECIAL_SCORE = 0,
	SPECIAL_TAI = 1
}

const types = ["score","tai"]
const rate = [5,2,1,1,1,1,1,1,1,1]

@onready var tip := $Control/Tip as Label
@onready var value := $Control/Value as Label

func special_calc_for_extra(grid: Array2D,source: Array[Vector2i], cracks: Control,now_pos: Vector2i)->Array[Vector2i]:
	return []

func call_add():
	var type = rand_type()
	var va = rand_value()
	tip.text = types[type]
	value.text = String.num(va)
	match type:
		SPECIAL_SCORE:
			GlobalSignal.add_score.emit(va)
		SPECIAL_TAI:
			GlobalSignal.add_tai.emit(va)

func rand_type()->int:
	var i = randi() % types.size()
	return i

# 先把数据限制到100以内
# 每10格都有自己的数值
func rand_value()->int:
	var r = randi() % 100
	var s = r / 10
	return rate[s]
