class_name InitCraks

signal wait_init_lines

var columns: int = 9
var rows: int = 11
var craks: Control
var pks:Array[PackedScene]
var grid: Array2D
var tree: AnimationTree

var g_line1: Array
var g_line2: Array
var tools:CraksTool

func _init(col: int, row: int, craks: Control, pkg: Array[PackedScene], grid: Array2D, tree: AnimationTree):
	self.columns=col
	self.rows=row
	self.craks=craks
	self.pks=pkg
	self.grid=grid
	self.tree=tree
	tools = CraksTool.new()
	set_generate_lines(tools.generate_line_data(columns),tools.generate_line_data(columns))

# 设置生成的两行方块数据
func set_generate_lines(line1: Array, line2: Array):
	g_line1=line1
	g_line2=line2

func start_wait():
	wait_init_lines.emit()

# 生成两行
func init_craks():
	var tools = CraksTool.new()
	tools.show_line_with_data(craks,0,g_line1,rows)
	tools.show_line_with_data(craks,1,g_line2,rows)
	grid.set_row(0,tools.get_line_from_data(g_line1))
	grid.set_row(1,tools.get_line_from_data(g_line2))
	var children := craks.get_children()
	var record :Dictionary = {}
	for i in children:
		var co = i as Control
		record[co.name]="OK"
	for i in children:
		var co = i as Control
		co.scale = Vector2(0.8,0.8)
		var tween = craks.get_tree().create_tween()
		var o = TweenTreeDone.new("parameters/InitCraks/conditions/InitEnd",co.name,record,tree)
		tween.tween_property(i, "scale", Vector2(1,1), 0.3)
		tween.tween_property(i, "scale", Vector2(1.05,1.05), 0.1)
		tween.tween_property(i, "scale", Vector2(1,1), 0.1)
		tween.tween_callback(o.end)
		tween.play()

func init_end():
	print("init 结束了!")
