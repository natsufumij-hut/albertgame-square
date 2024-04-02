extends Node

var key: String = "square-client-ke"
var path: String = "user://square-local.sq"

# 服务端数据
var serverData: Dictionary = {
	"max_score": 0,
	"max_level": 1,
	"unlimit_max": 0,
}
# 客户端数据
var localData: Dictionary ={
	"max_score": 0,
	"max_level": 1,
	"unlimit_max": 0,
	"tai": 0
}

func _ready():
	loadLocal()
	GlobalSignal.add_tai.connect(self.add_tai)

# 读取本地资源
func loadLocal():
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ,key)
	if file!=null:
		var content = file.get_as_text()
		var data = dec_data(content)
		localData.merge(data,true)

func updateMaxScore(sc: int)->bool:
	if sc > localData.max_score:
		localData.max_score=sc
		putLocal()
		return true
	else:
		return false

func updateMaxUnLimitScore(sc: int)->bool:
	if sc > localData.unlimit_max:
		localData.unlimit_max=sc
		putLocal()
		return true
	else:
		return false


func updateMaxLevel(le: int):
	if le > localData.max_level:
		localData.max_level=le
		putLocal()

func add_tai(tai: int):
	var t = localData.tai
	t += tai
	localData.tai = t
	GlobalSignal.update_tai.emit(t)
	putLocal()

func consumer_tai(ta: int)->bool:
	var t = localData.tai
	if t-ta<0:
		return false
	else:
		localData.tai = t-ta
		GlobalSignal.update_tai.emit(localData.tai)
		putLocal()
		return true

func putLocal():
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE,key)
	var content = enc_data(localData)
	file.store_string(content)

func setServerData():
	pass


# 加密对象到文本
func enc_data(anyJson: Variant)->String:
	var js = JSON.stringify(anyJson)
	return js

# 解密文本到对象
func dec_data(json)->Variant:
	var data = JSON.parse_string(json)
	return data
	
