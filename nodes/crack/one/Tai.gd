extends SpecialCrack


const types = ["score","tai"]
const rate = [5,2,1,1,1,1,1,1,1,1]

@onready var tip := $Control/Tip as Label
@onready var value := $Control/Value as Label

func call_add():
	var va = rand_value()
	value.text = String.num(va)
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
