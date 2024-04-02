class_name CrackScript
extends Control

const CODE_SPECIAL="Special"
const CODE_NORMAL = "Normal"

@export var crack_size: = 1 #当前尺寸
@export var alive := 0 #当前存活
@export var code :String #方块代码
@export var texture_code: String #方块纹理代码

var cracks: Control

