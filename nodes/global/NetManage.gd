extends Node

const GAP := "PACK-GAP-0010"

var clientTcp := StreamPeerTCP.new() as StreamPeerTCP
var host = "192.168.2.224"
var port = 1234

const MAX_RETRY_TIMES = 1000
const CLIENT_UNKNOWN = "CLIENT_UNKNOWN"
var retry_times_count_down = MAX_RETRY_TIMES

var key := "1234567887654321"
var aes: = AESContext.new()
var client_id:String = CLIENT_UNKNOWN
var play_id: String = ""
var user_id = ""
var callDict :Dictionary = {}
var start_recei: bool = false
var msg_byte: PackedByteArray = []

func _ready():
	#link_start()
	pass

func link_start():
	var error = clientTcp.connect_to_host(host,port)
	var e = clientTcp.poll()
	var s = clientTcp.get_status()
	reconnect()

func _process(delta):
	var s = clientTcp.get_status()
	if clientTcp.get_status()==StreamPeerTCP.STATUS_CONNECTED:
		clientTcp.poll()
		var va = clientTcp.get_available_bytes()
		if va!=0:
			if start_recei:
				var result = clientTcp.get_data(va)
				msg_byte.append_array(get_data(result))
			else:
				msg_byte.clear()
				start_recei=true
				print("start bytes...")
				var result = clientTcp.get_data(va)
				msg_byte.append_array(get_data(result))
		else:
			if start_recei:
				slap_message()
				start_recei=false

func get_data(result: Array)->PackedByteArray:
	var error = result[0]
	var data = result[1]
	if error==0:
		return data
	else:
		print("receive error,",error)
		return []

func slap_message():
	print("start bytes...")
	print(msg_byte.get_string_from_utf8())
	if msg_byte.size()>2:
		var datas = dec_with_gap(msg_byte)
		for data in datas:
			if !data.operate:
				print("操作异常!!")
				print(data.body)
			print("[network] receive msg: ",JSON.stringify(inst_to_dict(data)))
			var call_id = data.type+data.model
			if callDict.has(call_id):
				var callable := callDict[call_id] as Callable
				callable.call(data)

func reconnect():
	var s = clientTcp.get_status()
	while s!=StreamPeerTCP.STATUS_CONNECTED && retry_times_count_down>0:
		print("当前状态,",s)
		clientTcp.poll()
		s = clientTcp.get_status()
		retry_times_count_down-=1
		if retry_times_count_down==0:
			break
	if clientTcp.get_status()!=StreamPeerTCP.STATUS_CONNECTED:
		print("连接失败!!!")
	retry_times_count_down = MAX_RETRY_TIMES

func enc(data: TransferData)->String:
	var template: Dictionary = {
		"fromId" : data.fromId,
		"model" : data.model,
		"type" : data.type,
		"operate"  : data.operate,
		"body" : data.body
	}
	var jso = JSON.stringify(template)
	aes.finish()
	aes.start(AESContext.MODE_ECB_ENCRYPT,key.to_utf8_buffer())
	var ps = jso.to_utf8_buffer()
	var mod = ps.size() % 16
	var last_byte = ps[ps.size()-1]
	if mod!=0:
		var pack = 16-mod
		ps[ps.size()-1]=10
		for i in range(1,pack):
			ps.append(10)
		ps.append(last_byte)
	var encode = aes.update(ps)
	var real = Marshalls.raw_to_base64(encode)
	return real

func pack_for_code(byte: PackedByteArray):
	var ps = byte
	var mod = ps.size() % 16
	var last_byte = ps[ps.size()-1]
	if mod!=0:
		var pack = 16-mod
		ps[ps.size()-1]=10
		for i in range(1,pack):
			ps.append(10)
		ps.append(last_byte)
	return ps

# 解密服务端的响应
func dec(byte: PackedByteArray)->TransferData:
	byte = pack_for_code(byte)
	aes.finish()
	aes.start(AESContext.MODE_ECB_DECRYPT,key.to_utf8_buffer())
	var pw = aes.update(byte)
	var word = pw.get_string_from_utf8()
	var dict = JSON.parse_string(word)
	var dat = TransferData.new()
	if dict==null:
		return null
	for key in dict:
		dat[key]=dict[key]
	return dat

func dec_with_gap(byte: PackedByteArray)->Array[TransferData]:
	var arr: Array[TransferData] = []
	var bytes: Array[PackedByteArray] = []
	var pack: PackedByteArray = []
	for b in byte:
		if b!=4:
			pack.append(b)
		else:
			bytes.append(pack)
			pack = []
	for item in bytes:
		if !item.is_empty():
			var str = item.get_string_from_utf8()
			var s = Marshalls.base64_to_raw(str)
			var data = dec(s)
			if data!=null:
				arr.append(data)
	return arr

func require(type:String,body: String,operate: bool = true):
	_send_data(TransferData.MODEL_REQUIRE,type,body,operate)

func response(type:String,body: String,operate: bool = true):
	_send_data(TransferData.MODEL_RESPONSE,type,body,operate)

func _send_data(model: String,type:String,body: String,operate: bool = true):
	var data := TransferData.new()
	data.type=type
	data.fromId=client_id
	data.model=model
	data.body=body
	data.operate=operate
	var enc = enc(data)
	if clientTcp.get_status()==StreamPeerTCP.STATUS_CONNECTED:
		clientTcp.put_data(enc.to_utf8_buffer())
	
func add_handler(model: String,type: String,  callable: Callable):
	var call_id = type+model
	callDict[call_id]=callable

## 是否已登录
func is_logined():
	return client_id!=CLIENT_UNKNOWN

## 获取用户id
func get_user_id():
	return user_id
