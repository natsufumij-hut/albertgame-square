class_name Score
extends HBoxContainer

signal update_score(sc: int)

var score := 0
@onready var label :Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_score()

# 添加分数
func add_score(sc: int):
	score += sc
	pri_set_score(score)

# 清空分数
func clear_score():
	score = 0
	pri_set_score(score)

# 设置分数，内部调用
func pri_set_score(sc: int):
	update_score.emit(sc)
	label.text = String.num(sc)
