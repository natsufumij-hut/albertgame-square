extends Control

@export var number: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pri_show_number(number)

# 显示设置的数字
func pri_show_number(num: int):
	var sa :String = String.num(num)
	for i in range(0,sa.length()):
		var s: String = sa.substr(i,1)
		var node = pri_find_node(i)
		var img = pri_find_img(s)
		node.texture = img.texture
		node.visible=true
		print("set ", s)

	if sa.length()<9:
		for i in range(sa.length(),9):
			var node = pri_find_node(i)
			node.visible=false

func pri_find_node(pos: int) -> TextureRect:
	var realPos = pos+1
	var sname = "Nums/n"+(String.num(realPos))
	return get_node(sname)

func pri_find_img(num: String) -> Sprite2D:
	var realPos = "NuBacks/Symb"+num
	return get_node(realPos)
