class_name BreakCrak

signal got_score(score: int)

var tools := CraksTool.new()
var special_hand := SpecialHandle.new()
var egg_hand := EasterEggHandle.new()

var columns: int = 9
var rows: int = 11
var craks: Control
var pks:Array[PackedScene]
var grid: Array2D
var tree: AnimationTree
var par: GPUParticles2D

# 等待模式，0为向上移动方块，1为等待用户移动
var mode : int = 0

# 需要最终消除的方块
var need_shake : Array[Vector2i] = []

func _init(col: int, row: int, craks: Control, pkg: Array[PackedScene], 
grid: Array2D, tree: AnimationTree, gpu: GPUParticles2D):
	self.columns=col
	self.rows=row
	self.craks=craks
	self.pks=pkg
	self.grid=grid
	self.tree=tree
	self.par=gpu
	special_hand.columns=col
	special_hand.grid=grid
	special_hand.craks=craks
	special_hand.rows=rows
	special_hand.handle_end.connect(self.special_end)
	egg_hand.egg_end.connect(self.easter_egg_end)
	

func break_crak():
	var result: Array[int]= []
	var tools:  = CraksTool.new()
	for i in range(0,rows):
		var check = check_line(grid.get_row(i))
		if check:
			result.append(i)
			
	var clearData: Array[Vector2i] = []
	need_shake.clear()
	# 处理找到的这些行的消消乐
	if result.is_empty():
		print("无需拆，等待执行...")
		tree.set("parameters/conditions/NoBreak",true)
	else:
		print(String.num(result.size())+"连消！！")
		got_score.emit(result.size())
		for i in result:
			add_shake(need_shake,i,clearData)
			var gpucopy: GPUParticles2D = par.duplicate()
			gpucopy.visible=true
			gpucopy.one_shot=true
			gpucopy.position.y = 48 * (rows-1-i)
			var po = gpucopy.position
			var de1 = gpucopy.position - Vector2(0,2)
			var de2 = gpucopy.position + Vector2(0,2)
			craks.add_child(gpucopy)
			var tween = craks.get_tree().create_tween()
			tween.tween_property(gpucopy, "position", de2, 0.3)
			tween.tween_property(gpucopy, "position", de1, 0.1)
			tween.tween_property(gpucopy, "position", po, 0.1)
			tween.tween_callback(gpucopy.queue_free)
			# 动画结束了的回调
			tween.play()
		update_data(clearData)
	tree.set("parameters/WaitHandle/conditions/UserHand",false)
	if need_shake.is_empty():
		print("无需拆，等待执行...")
		tree.set("parameters/conditions/NoBreak",true)
	else:
		print("need shake!")
		special_crak(need_shake)

	#for i in result:
		#tools.del_line(craks,i,grid.get_row(i))
		#grid.fill_row(i,0)

# break 的 流程如下
# 1.找到特殊方块，如果有，进行特殊动画，如果有另外破坏的，需要在动画最后返回一个列表
# 2.找到彩蛋，如果有，进行彩蛋动画
# 3.最后，进行需要破坏的方块进行摇晃并删除
# 特殊方块特效
func special_crak(clearData: Array[Vector2i]):
	special_hand.handle_special(clearData)

# 特殊方块特效结束
func special_end(exta: Array[Vector2i]):
	tools.merge_array(need_shake,exta)
	easter_egg(need_shake)

# 彩蛋
func easter_egg(clearData: Array[Vector2i]):
	egg_hand.handle_easter_egg(clearData,craks)

# 彩蛋结束
func easter_egg_end():
	shake_cracks()

func shake_cracks():
	var dict: Dictionary = {}
	for item in need_shake:
		shake_node(item,dict)

func check_line(arr: Array)->bool:
	for i in arr:
		if i==0:
			return false
	return true

func find_node(x: int,y: int)->Control:
	return craks.get_node("crak_"+String.num(x)+"_"+String.num(y))

# 摇晃的方格
func add_shake(need_shake: Array[Vector2i],x: int,clearDict: Array[Vector2i]):
	var arr = grid.get_row(x)
	var j = 0
	while j<arr.size():
		var t = arr[j]
		if t==0:
			j+=1
		else:
			var dest := find_node(x,j) as CrackScript
			if dest.alive>0:
				var hand = tree.get("parameters/WaitHandle/conditions/UserHand")
				if hand:
					print("check..alive")
					dest.alive-=1
					if dest.alive==0:
						var event = dest.get_node("Event")
						if event!=null:
							event.queue_free()
			else:
				for y in range(0,t):
					clearDict.append(Vector2i(x,j+y))
				need_shake.append(Vector2i(x,j))
			j+=t


func shake_node(loc: Vector2i,record: Dictionary):
	var one = tools.get_cell(craks,loc.x,loc.y) as Control
	var tween = one.get_tree().create_tween()
	var pos = one.position - Vector2(2,0)
	var pos2 = one.position + Vector2(2,0)
	var tween_manage := TweenManage.new(one.name,record)
	tween_manage.all_end.connect(self.shake_finished)
	tween.tween_property(one, "position", pos , 0.1)
	tween.tween_property(one, "position", pos2, 0.1)
	tween.tween_property(one, "position", pos , 0.1)
	tween.tween_property(one, "position", one.position, 0.1)
	tween.tween_callback(one.queue_free)
	tween.tween_callback(tween_manage.end)
	tween.play()

func shake_finished():
	print("shaked finished111")
	tree.set("parameters/conditions/HasBreaked",true)

func update_data(array: Array[Vector2i]):
	for i in array:
		grid.set_cell(i.x,i.y,0)


