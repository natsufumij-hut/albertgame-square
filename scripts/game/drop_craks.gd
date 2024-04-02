class_name DropCraks

var columns: int = 9
var rows: int = 11
var craks: Control
var pks:Array[PackedScene]
var grid: Array2D
var tree: AnimationTree

func _init(col: int, row: int, craks: Control, pkg: Array[PackedScene], grid: Array2D, tree: AnimationTree):
	self.columns=col
	self.rows=row
	self.craks=craks
	self.pks=pkg
	self.grid=grid
	self.tree=tree

# 掉落
func handle_drop():
	var check :CrakCheck = CrakCheck.new()
	var resu :Array2D = Array2D.new()
	var result := check.check_down_craks(grid,resu,9,11)
	if result.is_empty():
		tree.set("parameters/Drop/conditions/DropEnd",true)
		return
	# 更新掉落之后的数据
	var record :Dictionary = {}
	for i in range(0,result.size()):
		var item = result[i]
		var find_name = "crak_"+String.num(item.row)+"_"+String.num(item.column)
		record[find_name]="ON"
	for i in range(0,result.size()):
		var item = result[i]
		var find_name = "crak_"+String.num(item.row)+"_"+String.num(item.column)
		var node = craks.get_node(find_name)
		if node!=null:
			moveNode(node,item.drop,record)
	update_data(grid,resu,result)

func update_data(now: Array2D, dest: Array2D, result ):
	for i in range(0,result.size()):
		var item = result[i]
		var find_name = "crak_"+String.num(item.row)+"_"+String.num(item.column)
		var dest_name = "crak_"+String.num(item.row-item.drop)+"_"+String.num(item.column)
		var node = craks.get_node(find_name)
		node.name = dest_name
	now.data = dest.data

# 掉落方块
func moveNode(one: Control,drop: int,record: Dictionary):
	var tween = craks.get_tree().create_tween()
	var de = one.position + Vector2(0, 48 * drop)
	var dep = de - Vector2(0,4)
	var s = TweenTreeDone.new("parameters/Drop/conditions/DropEnd",one.name,record,tree)
	tween.tween_property(one, "position", de, 0.3 * abs(drop))
	tween.tween_property(one, "position", dep, 0.10)
	tween.tween_property(one, "position", de, 0.10)
	tween.tween_callback(s.end)
	tween.play()
