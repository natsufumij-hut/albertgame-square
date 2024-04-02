## 等待处理方块
## 1.等待用户移动方块、使用道具等
## 2.等待系统放方块/特效
class_name HandleCrak

signal wait_next_line
signal failed

enum {
	MODE_NO_WAIT,
	MODE_WAIT_MOVE,
	MODE_WAIT_UP
}

var columns: int = 9
var rows: int = 11
var craks: Control
var pks:Array[PackedScene]
var grid: Array2D
var tree: AnimationTree
var mode: int = MODE_NO_WAIT # 模式，-1当前没有等待状态， 0 等待用户操作，1 系统操作
var mcount: int = 0
var tools: = CraksTool.new()

func _init(col: int, row: int, craks: Control, pkg: Array[PackedScene], grid: Array2D, tree: AnimationTree):
	self.columns=col
	self.rows=row
	self.craks=craks
	self.pks=pkg
	self.grid=grid
	self.tree=tree

func reset():
	mcount = 0
	mode = MODE_NO_WAIT

func handle_crak():
	var record:Dictionary = {}
	if mcount%2==0 && !is_all_empty():
		mode = MODE_WAIT_MOVE
		tree.set("parameters/Event/conditions/NeedEvent",false)
		tree.set("parameters/Event/conditions/NoNeedEvent",true)
	else:
		mode = MODE_WAIT_UP
	if mode==MODE_WAIT_UP:
		wait_next_line.emit()

func is_all_empty()->bool:
	for i in range(0,rows):
		for j in range(0,columns):
			if grid.get_cell(i,j)!=0:
				return false
	return true

func handle_end():
	mode = MODE_NO_WAIT
	mcount+=1
	print("等待结束!!!")
	tree.set("parameters/WaitHandle/conditions/UserHand",true)
	var hand = tree.get("parameters/WaitHandle/conditions/UserHand")
	tree.set("parameters/WaitHandle/conditions/WaitEnd",true)


var new_line:Array
func set_new_line(line: Array):
	new_line = line

func handle_up():
	set_new_line(tools.generate_line(columns))
	move_up()

class MoveOne:
	var grid: HandleCrak
	var record: Dictionary
	var id: String
	var model: String
	var newname: String
	var newrow: int
	func _init(grid: HandleCrak,model: String, id: String,record: Dictionary,newrow:int, newcolumn: int):
		self.grid=grid
		self.record=record
		self.id=id
		self.newrow=newrow
		newname="crak_"+String.num(newrow)+"_"+String.num(newcolumn)
	func end():
		record.erase(id)
		if record.is_empty():
			grid.move_up_end()
	func update_data():
		var tools := CraksTool.new()
		var node = grid.craks.get_node(id)
		node.name=newname

# 掉落方块
func move_node(one: Control,drop: int,record: Dictionary, row: int, column: int):
	var tween = craks.get_tree().create_tween()
	var de = one.position + Vector2(0, 48 * drop)
	var dep = de - Vector2(0,4)
	var s = MoveOne.new(self,"",one.name,record,row+1,column)
	tween.tween_property(one, "position", de, 0.3 * abs(drop))
	tween.tween_property(one, "position", dep, 0.10)
	tween.tween_property(one, "position", de, 0.10)
	tween.tween_callback(s.update_data)
	tween.tween_callback(s.end)
	tween.play()

# 向上推一行
func move_up():
	if check_is_full():
		print("输了!!!!!!!")
		failed.emit()
		return
	var record: Dictionary = {}
	var i = rows-2
	var no_move = true
	while i>=0:
		var j = 0
		while j<columns:
			var t = grid.get_cell(i,j)
			if t==0:
				j+=1
			else:
				no_move=false
				var find_name = "crak_"+String.num(i)+"_"+String.num(j)
				var dest = craks.get_node(find_name)
				if dest!=null:
					record[dest.name]="OK"
					move_node(dest,-1,record,i,j)
				j+=t
		i-=1
	if no_move:
		move_up_end()
	
## 判断是否已满,如果已满，则输了
func check_is_full()->bool:
	for i in grid.get_row(rows-1):
		if i!=0:
			return true
	return false

# 上移一行结束
func move_up_end():
	tree.set("parameters/Event/conditions/NeedEvent",true)
	tree.set("parameters/Event/conditions/NoNeedEvent",false)
	# 移除尾部
	grid.remove_row_end()
	grid.insert_row_start([])
	var n_line = tools.get_line_from_data(new_line)
	# 添加头部
	grid.set_row(0,n_line)
	tools.show_line_with_data(craks,0,new_line,rows)
	var children := craks.get_children()
	var record :Dictionary = {}
	var i = 0
	while i<columns:
		var t = grid.get_cell(0,i)
		if t==0:
			i+=1
			continue
		var find_name = "crak_0_"+String.num(i)
		i+=t
		var dest = craks.get_node(find_name)
		if dest==null:
			continue
		var co = dest as Control
		co.scale = Vector2(0.8,0.8)
		var tween = craks.get_tree().create_tween()
		var o = TweenTreeDone.new("parameters/WaitHandle/conditions/WaitEnd",co.name,record,tree)
		tween.tween_property(dest, "scale", Vector2(1,1), 0.3)
		tween.tween_property(dest, "scale", Vector2(1.05,1.05), 0.1)
		tween.tween_property(dest, "scale", Vector2(1,1), 0.1)
		tween.tween_callback(o.end)
		tween.play()

var dragging = false
var dest: Control = null

func find_real_px(px: int,row: int) -> int:
	var x = px
	var j = 0
	while j<columns:
		var t = grid.get_cell(row,j)
		if t!=0 and t!=null:
			var end = j+t
			if px>=j and px<end:
				return j
			j+=t
		else:
			j+=1
	return -1 #没找到

var lastX: float = 0.0
var row:=0
var column:=0
var min_x:=0
var max_x:=0

func _pri_handle_input(event,panel):
	if mode != MODE_WAIT_MOVE:
		print("当前不允许移动!!")
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		press_touch(event.position,event.pressed,panel)
	
	if event is InputEventScreenTouch:
		press_touch(event.position,event.pressed,panel)

	if event is InputEventMouseMotion and dragging:
		motion(event.position,panel)
	
	if event is InputEventScreenDrag:
		motion(event.position,panel)


func press_touch(position: Vector2, press: bool,panel: Control):
	# Stop dragging if the button is released.
		if dragging and not press:
			dragging = false
			update_data(dest,row,column)
			print("更新了位置信息")
			return

		var pos = position - panel.position
		var px = (pos.x / 48) as int
		var py = (11 - pos.y / 48) as int
		px = find_real_px(px,py)
		row=py
		column=px
		if px==-1:
			dragging = false
			return
		var n = "crak_"+String.num(py)+"_"+String.num(px)
		min_x=max_left(py,px)
		max_x=max_right(py,px,columns)
		dest = craks.get_node(n)
		print("find?",dest)
		lastX = pos.x
		# Start dragging if the click is on the sprite.
		if !dragging and press:
			dragging = true

func motion(position: Vector2,panel: Control):
	var pos = position - panel.position
		# While dragging, move the sprite with the mouse.
	if dest==null:
		dragging = false
		return
	var delta = pos.x - lastX
	lastX = pos.x
	var destX = rect_x(dest.position.x + delta)
	dest.position.x=destX

func update_data(dest: Control,row: int, column: int):
	var t = grid.get_cell(row,column)
	var px = dest.position.x
	var nP = (px / 48) as int
	var xMin = nP * 48
	var xMax = (nP+1) * 48
	var gMin = px - xMin
	var gMax = xMax - px
	var destX = 0
	if gMin > gMax:
		destX = nP+1
	else:
		destX = nP
	dest.position.x = destX * 48
	if destX == column:
		return
	tools.del_crak_data(grid,row,column)
	tools.set_crak_data(grid,row,destX,t)
	dest.name = "crak_"+String.num(row)+"_"+String.num(destX)
	# 放置完毕，设置状态机
	var list = tree.get_property_list()
	var dict :Dictionary = {
		"name": "parameters/WaitHandle/conditions/UserHand",
		"type": TYPE_BOOL
	}
	list.append(dict)
	tree.set("parameters/WaitHandle/conditions/UserHand",true)
	var hand = tree.get("parameters/WaitHandle/conditions/UserHand")
	tree.set("parameters/WaitHandle/conditions/WaitEnd",true)

func max_left(row: int, column: int)->int:
	var x = column - 1
	var t = grid.get_cell(row,column)
	while x>=0:
		var tx = grid.get_cell(row,x)
		if tx!=0:
			return (x+1) * 48
		x-=1
	return 0

func max_right(row: int, column: int,total_column: int)->int:
	var t = grid.get_cell(row,column)
	var x = column + t
	while x<total_column:
		var tx = grid.get_cell(row,x)
		if tx!=0:
			return ((x-t) * 48)
		x+=1
	return (total_column-t) * 48

func rect_x(x: int)->int:
	if x<min_x:
		return min_x
	if x>max_x:
		return max_x
	return x
