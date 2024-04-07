class_name LoadLevel

## LevelLine.txt
## blue=b,green=g,yellow=y,grey=r
## chiken=c,takara=t,inazuma=i,bask=s
## tai=a,cigrate=ci,diao=d,zhong=zh
##
## 
## LINE 1b,1b,2b,2b,3g,3g,3g,1t
## LINE 1b,2g,2g,0,0,0,0,0,0
## LINE 3g,3g,3g,1b,0,0,1b,1g,0
## LINE 1y,1y,1c,0,0,0,0,1g,0
## EVENT 0
const idMap: Dictionary = {
	"b": "Blue",
	"g": "Green",
	"y": "Yellow",
	"r": "Grey",
	"c": "Chiken",
	"t": "Takara",
	"i": "Inazuma",
	"s": "Bask",
	"a": "Tai",
	"ci": "Cigrate",
	"d": "Diao",
	"zh": "Zhong"
}

const special: Dictionary = {
	"t": "Takara",
	"i": "Inazuma",
	"a": "Tai",
	"ci": "Cigrate",
}

func load_line(line: String) -> LevelLine:
	var seg = line.split(" ")
	var cmd = seg[0]
	var li = seg[1]
	var column = LevelLine.new()
	if cmd=="LINE":
		column.type=LevelLine.TYPE_LINE
		column.line = load_data(li)
	elif cmd=="EVENT":
		column.type = LevelLine.TYPE_EVENT
		column.event = li.to_int()
	return column

# 1y,1y,1c,2g,2g,0,0,1g,0
func load_data(line: String,columns = 9) -> Array[CrakData]:
	var arr = line.split(",")
	var array: Array[CrakData] = []
	var j := 0
	while j<arr.size():
		var i: String = arr[j]
		if i=="0":
			array.append(CrakData.empty())
			j+=1
		else:
			var data = CrakData.new()
			var num = i.substr(0,1)
			var id = i.substr(1,i.length()-1)
			data.size = num.to_int()
			if special.has(id):
				data.code="Special"
			else:
				data.code="Normal"
			data.texture_code = idMap[id]
			array.append(data)
			j+=num.to_int()
	return array

func load_level(level: int) -> Array[LevelLine]:
	var path = "res://levels/level"+String.num(level)+".txt"
	var file := FileAccess.open(path, FileAccess.READ)
	if file==null:
		print("找不到文件!!!!")
	var content = file.get_as_text()
	var split = content.split("\n")
	var arr: Array[LevelLine] = []
	for line in split:
		if !line.is_empty():
			var li = load_line(line)
			arr.append(li)
	return arr
