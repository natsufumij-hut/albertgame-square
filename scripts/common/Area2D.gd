# ========================================================
# 名称：Array2D
# 类型：自定义类
# 简介：二维数组类，专用于处理二维数组
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-09-24 23:30:57
# 最后修改时间：2023年9月25日21:38:07
# ========================================================

class_name Array2D

var data:Array

func _init(p_data:Array = []):
	data = p_data

# 返回指定行数和列数以及填充内容的二维数组
static func fill_rect(rows:int,cols:int,fill_content) -> Array2D:
	# 构造行
	var row = Array()
	row.resize(cols)
	row.fill(fill_content)
	# 构造二维数组
	var arr2 = Array()
	arr2.resize(rows)
	arr2.fill(row)
	return Array2D.new(arr2)

# 返回一个使用介于min到max之间的随机数整数填的二维数组
static func fill_rect_random(rows:int,cols:int,min:int,max:int) -> Array2D:
	# 构造一维数组
	var arr = []
	arr.resize(rows * cols)
	# 填充随机数
	arr = arr.map(func(num):
		return randi_range(min,max)
	)
	return Array2D.array_to_array2d(arr,cols)


# 控制台显示
func show() -> void:
	if data.is_empty():
		print(data)
	else:
		for row in data:
			print(row)

# 用内容填充整个二维数组
func fill(fill_content) -> void:
	for row in data:
		row.fill(fill_content)

# 用min到max之间的随机数填充当前二维数组
func random_fill_int(min:int,max:int):
	data = fill_rect_random(data.size(),data[0].size(),min,max).data

# 用内容填充整个二维数组边界
func fill_border(fill_content) -> void:
	for i in range(data.size()):
		if i == 0 or i == data.size() - 1:
			data[i] = data[i].map(func(num):
				return fill_content;
			)
			pass
		else:
			data[i][0] = fill_content
			data[i][data[i].size()-1] = fill_content

# 获取指定位置 - 上方 - 单元格值或无
func get_up(row:int,col:int):
	return get_cell(row-1,col)

# 获取指定位置 - 下方 - 单元格值或无
func get_down(row:int,col:int):
	return get_cell(row+1,col)

# 获取指定位置 - 左侧 - 单元格值或无
func get_left(row:int,col:int):
	return get_cell(row,col - 1)

# 获取指定位置 - 右侧 - 单元格值或无
func get_right(row:int,col:int):
	return get_cell(row,col + 1)

# 获取指定位置 - 上方 - 单元格值或无
func get_upv(pos:Vector2):
	return get_up(pos.x,pos.y)

# 获取指定位置 - 下方 - 单元格值或无
func get_downv(pos:Vector2):
	return get_cell(pos.x,pos.y)

# 获取指定位置 - 左侧 - 单元格值或无
func get_leftv(pos:Vector2):
	return get_cell(pos.x,pos.y)

# 获取指定位置 - 右侧 - 单元格值或无
func get_rightv(pos:Vector2):
	return get_cell(pos.x,pos.y)


# =================================== 获取/设定值 ===================================
# ----------------------------------- 行 -----------------------------------
# 获取行
func get_row(index:int):
	return data[index]

# 设定行 - 用新的数组取代原来的行
func set_row(index:int,new_row:Array) -> void:
	data[index] = new_row

# 将行元素全部填充为fill_content
func fill_row(index:int,fill_content) -> void:
	var new_row = Array()
	new_row.fill(fill_content)
	data[index] = new_row

func fill_row_line(index: int, columns: int, fill_content)->void:
	var new_row = []
	for i in range(0,columns):
		new_row.append(fill_content)
	data[index] = new_row

# 在指定位置插入新行
func insert_row(pos:int,new_row:Array) -> void:
	data.insert(pos,new_row)

# 在开头插入新行
func insert_row_start(new_row:Array) -> void:
	data.insert(0,new_row)

# 在末尾插入新行
func insert_row_end(new_row:Array) -> void:
	data.append(new_row)

# 在末尾添加行
func append_row(new_row:Array) -> void:
	data.append(new_row)

# 移除指定位置行
func remove_row(pos:int) -> void:
	data.remove_at(pos)

# 移除第一行
func remove_row_start() -> void:
	data.remove_at(0)

# 移除末尾行
func remove_row_end() -> void:
	data.remove_at(data.size()-1)

# 重置 - 不修改行列大小，所有元素重置为int_val（默认为null）
func reset(int_val = null) -> void:
	fill(int_val)

# 清除所有行 -- data.resize(0)
func clear() -> void:
	data.clear()

# 按行进行洗牌
func shuffle_with_rows() -> void:
	# 所有行自己进行洗牌
	for row in data:
		row.shuffle()
	# 对行顺序进行洗牌
	data.shuffle()

# 整体洗牌 
func shuffle() -> void:
	# 转为一维数组
	var arr1d = to_array()
	# 对所有元素进行洗牌
	arr1d.shuffle()
	# 再次转化为数组
	data = array_to_array2d(arr1d,data[0].size()).data

# Array --> Array2D
static func array_to_array2d(array:Array,num:int) -> Array2D:
	var arr = array.duplicate(true)
	var arr_back:Array[Array] = []
	while !arr.is_empty():
		var sub_arr:Array
		for i in range(num if num < arr.size() else arr.size()):
			sub_arr.append(arr[0])
			arr.remove_at(0)
		arr_back.append(sub_arr)
		
	return Array2D.new(arr_back)

# Array2D --> Array
func to_array() -> Array:
	var arr = data.duplicate(true)
	var arr1:Array = []
	if arr.size() >0:
		arr1 = arr[0] if typeof(arr[0]) == TYPE_ARRAY else [arr[0]]
		for i in range(1,arr.size()):
			arr1.append_array(arr[i] if typeof(arr[i]) == TYPE_ARRAY else [arr[i]])
	return arr1

# ----------------------------------- 列 -----------------------------------
# 获取列
func get_col(index:int):
	var col = []
	for row in data:
		col.append(row[index])
	return col

# 设定列
func set_col(index:int,new_col:Array) -> void:
	for i in range(data.size()):
		data[i][index] = new_col[i]

# 将行元素全部填充为fill_content
func fill_col(index:int,fill_content) -> void:
	var new_col = Array()
	new_col.resize(data.size())
	new_col.fill(fill_content)
	set_col(index,new_col)

# ----------------------------------- 单元格 -----------------------------------
# 获取单元格的值
func get_cell(row_idx:int,col_idx:int):
	# 超出范围
	if row_idx not in range(data.size()) or col_idx not in range(data[0].size()):
		return null
	return data[row_idx][col_idx]

# 获取单元格的值 -- Vector2参数形式
func get_cellv(cellv:Vector2):
	return data[cellv.x][cellv.y]

# 设定单元格的值
func set_cell(row_idx:int,col_idx:int,new_val):
	data[row_idx][col_idx] = new_val

# 设定单元格的值 -- Vector2参数形式
func set_cellv(cellv:Vector2,new_val):
	data[cellv.x][cellv.y] = new_val
