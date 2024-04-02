class_name CrakCheck

#掉落方块的位置
class DropPos:
	var column: int
	var row: int
	var crak_length: int #方块长度
	var drop: int
	static func Pos(i: int,j: int,crak_len: int,dr: int)->DropPos:
		var d = DropPos.new()
		d.column=j
		d.crak_length=crak_len
		d.row=i
		d.drop=dr
		return d

# 检查需要下坠的方块
func check_down_craks(craks: Array2D,result: Array2D,columns: int, rows: int) -> Array[DropPos]:
	var dup: Array2D = Array2D.new(craks.data.duplicate())
	var dropList :Array[DropPos] = []
	for i in range(1,rows):
		var j = 0
		while j<columns:
			var t = craks.get_cell(i,j)
			if t==0:
				j=j+1
			elif t==1:
				# 获取下坠的格子数，如果为0则忽略
				var drop = _pri_get_drop_pos(dup,i,j)
				if drop!=0:
					_pri_drop_crack(dup,i,j,drop)
					var dr = DropPos.Pos(i,j,1,drop)
					dropList.append(dr)
				j+=t
			else:
				# 默认最小应该做一个很大的数
				var MIN = 100
				# 获取整条方块每个格子的下坠格子数，取最小值，如果为0则忽略
				for m in range(0,t):
					var drop = _pri_get_drop_pos(dup,i,j+m)
					if drop<MIN:
						MIN=drop
				if MIN!=0:
					# 将这一整块都
					for n in range(j,j+t):
						_pri_drop_crack(dup,i,n,MIN)
					var dr = DropPos.Pos(i,j,t,MIN)
					dropList.append(dr)
				j+=t
	result.data=dup.data
	return dropList

# 计算掉落的格子数
func _pri_get_drop_pos(craks: Array2D, i: int, j:int) -> int:
	var x = i - 1
	var count = 0
	while x>=0:
		var q = craks.get_cell(x,j)
		if q==0:
			count+=1
		else:
			break
		x-=1
	return count

# 掉落方块
func _pri_drop_crack(craks: Array2D,i: int,j: int, drop: int):
	var x = craks.get_cell(i,j)
	craks.set_cell(i,j,0)
	craks.set_cell(i-drop,j,x)
