class_name CraksTool

const types = ["one","two","three"]
const code = ["normal", "special"]
const ones_normal = ["Green","Blue","Grey","Chiken","Bask","Yellow"]
const ones_special = ["Takara","Tai"]
const twos_normal = ["Green","Blue","Grey","Yellow", "Zhong"]
const twos_special = ["Inazuma"]
const threes_normal = ["Green","Blue","Grey","Diao","Yellow"]
const threes_special = ["Cigrate"]

const dict: Dictionary = {
		"1_0": ones_normal,
		"1_1": ones_special,
		"2_0": twos_normal,
		"2_1": twos_special,
		"3_0": threes_normal,
		"3_1": threes_special
}

# 随机生成一行方块
func generate_line(columns: int):
	var gap = 0
	var arr:Array[int] = []
	while gap<columns:
		var r = randi() % 4
		if r!=0:
			if (gap+r) > columns:
				for i in range(gap,columns):
					arr.append(0)
				break
			else:
				for i in range(0,r):
					arr.append(r)
					gap+=1
		else:
			arr.append(0)
			gap+=1
	return arr

func get_line_from_data(array: Array[CrakData]):
	var arr:Array[int] = []
	for data in array:
		var size = data.size
		if size!=0:
			for i in range(0,size):
				arr.append(size)
		else:
			arr.append(0)
	return arr

func generate_line_data(columns: int) -> Array[CrakData]:
	var gap = 0
	var arr:Array[CrakData] = []
	while gap<columns:
		var r = randi() % 4
		if r!=0:
			if (gap+r) > columns:
				for i in range(gap,columns):
					arr.append(CrakData.empty())
				break
			else:
				for i in range(0,r):
					gap+=1
				var isSpecial = randi() % 2
				var sid = String.num(r)+"_"+String.num(isSpecial)
				var dest_arr := dict[sid] as Array
				if dest_arr==null or dest_arr.is_empty():
					continue
				var d = randi() % dest_arr.size()
				var co = dest_arr[d]
				var data = CrakData.new()
				data.size = r
				data.code = code[isSpecial]
				data.texture_code = co
				
				arr.append(data)
		else:
			arr.append(CrakData.empty())
			gap+=1
	return arr
	

# 在位置上显示方块
func show_crak(crakControls: Control,list: Array[PackedScene], x: int,y: int,rows: int, crak: int):
	if crak==0:
		return
	var v :Control = list[crak-1].instantiate()
	v.position.x = y * 48
	v.position.y = (rows-1-x) * 48
	v.visible = true
	v.name="crak_"+String.num(x)+"_"+String.num(y)
	print("x,y,crak:",x,",",y,",",crak)
	crakControls.add_child(v)

func show_crak_with_data(crakControls: Control, x: int,y: int,rows: int,data: CrakData ):
	if data.size==0:
		return
	var pack: PackedScene = got_path_crack(data.size,data.texture_code)
	if pack==null:
		var id = data.code +"_"+ data.texture_code
		print("找不到,",id)
		return
	var v : = pack.instantiate() as CrackScript
	v.position.x = y * 48
	v.position.y = (rows-1-x) * 48
	v.visible = true
	v.name="crak_"+String.num(x)+"_"+String.num(y)
	print("x,y,crak:",x,",",y,",",pack)
	crakControls.add_child(v)

func got_path_crack(size: int, texture_code: String) -> PackedScene:
	var path = "res://nodes/crack/"+types[size-1]+"/"+texture_code+".tscn"
	var packedScene := load(path) as PackedScene
	return packedScene

# 显示一整行
func show_line(crakControls: Control,list: Array[PackedScene],x :int, arr: Array[int], rows: int):
	var j = 0
	while j<arr.size():
		var t = arr[j]
		if t==0:
			j=j+1
		else:
			show_crak(crakControls,list,x,j,rows,arr[j])
			j=j+t

func show_line_with_data(crakControls: Control,x :int, arr: Array[CrakData], rows: int):
	var j = 0
	var pos = 0
	while j<arr.size():
		var data = arr[j]
		show_crak_with_data(crakControls,x,pos,rows,data)
		if data.size!=0:
			pos += data.size
		else:
			pos +=1
		j+=1

# 删除一行
func del_line(crakControls: Control, row: int, arr: Array[int]):
	var j = 0
	while j<arr.size():
		var t = arr[j]
		if t==0:
			j+=1
		else:
			del_crak(crakControls,row,j)
			j+=t
		
# 删除单个
func del_crak(crakControls: Control, x:int, y: int):
	var find_name="crak_"+String.num(x)+"_"+String.num(y)
	var node = crakControls.get_node(find_name)
	if node!=null:
		node.queue_free()

func del_crak_data(grid: Array2D, row: int,column: int):	
	var size:int = grid.get_cell(row,column)
	for i in range(0,size):
		grid.set_cell(row,column+i,0)

func clear_crack(crackControls: Control, row:int, column:int, grid: Array2D):
	var rx = find_real_px(grid,column,row,11)
	if rx==-1:
		return
	var t = grid.get_cell(row,rx)
	if t!=0:
		del_crak(crackControls,row,rx)
		del_crak_data(grid,row,rx)

func set_crak_data(grid: Array2D, row: int,column: int, size: int):
	for i in range(0,size):
		grid.set_cell(row,column+i,size)

func get_cell(crack: Control, row:int, column: int):
	var find_name="crak_"+String.num(row)+"_"+String.num(column)
	return crack.get_node(find_name)	

func calc_pos(crack: Control, pos: Vector2,size: Vector2,rows: int)->Vector2i:
	var gp = crack.global_position
	var delta = pos - gp
	var px := (delta.x / size.x) as int
	var py := (delta.y / size.y) as int
	py = rows - 2 - py
	#Vector2i(row,column)
	return Vector2i(py,px)

## arr2添加到arr中
func merge_array(arr: Array[Vector2i], arr2: Array[Vector2i]):
	var dict: Dictionary = {}
	for item in arr:
		var key = String.num(item.x)+"-"+String.num(item.y)
		dict[key]=true
	for item in arr2:
		var key = String.num(item.x)+"-"+String.num(item.y)
		if !dict.has(key):
			arr.append(item)

## 查询方块，是否包含全部的指定code
## codes = [
##  { "name": "codeA", "num": 1},
##  { "name": "codeB", "num": 1},
## ]
func check_cracks_has(craks: Array[CrackScript], code: Array[Dictionary])->bool:
	var map: Dictionary = {}
	for c in code:
		map[c.name]=c.num
	for item in craks:
		var key = item.texture_code
		if map.has(key):
			var num = map[key]
			num -= 1
			# 为0时去除
			if num==0:
				map.erase(key)
			else:
				map[key]=num
			# 如果map的key全部都达成了，返回true
			if map.is_empty():
				return true
	# 否则返回false
	return false

func find_real_px(grid: Array2D,px: int,row: int,columns: int) -> int:
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
