extends Control

@onready var id_input := $CanvasLayer/Id/LineEdit as LineEdit
@onready var pass_input := $CanvasLayer/Pass/LineEdit as LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	NetManage.add_handler(TransferData.MODEL_RESPONSE,TransferType.TYPE_LOGIN,self.login_response)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_login_pressed():
	NetManage.link_start()
	var id_in = id_input.text
	var pass_in = pass_input.text
	var body = id_in+","+pass_in
	NetManage.require(TransferType.TYPE_LOGIN,body,true)

func _on_exit_login_pressed():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

func login_response(body: TransferData):
	if body.operate:
		NetManage.client_id=body.body
		NetManage.user_id=id_input.text
		$LoginResult.visible = true
		print("登录成功!")
	else:
		print("登录出错,",body.body)
