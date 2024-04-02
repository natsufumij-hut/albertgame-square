class_name CrackEvent
extends Control


# 事件结束
signal event_end

# 数据
var grid: Array2D
# 方块父类
var craks: Control
var result: Array[Vector2i]

# 系统调用
func start_crak_event():
	result = event_before_start()
	event_start()

# 覆盖此方法实现多态,开始事件之前计算
func event_before_start() -> Array[Vector2i]:
	return []

# 覆盖此方法实现多态,在动作结束后调用signal event_end()
func event_start():
	var anim := $AnimationPlayer as AnimationPlayer
	anim.play("anim")

# 调用此方法结束事件,anim动画结束的回调，实现自己的事件后置动作
func event_call_end():
	pass

# 调用此方法表示事件全部完成
func call_end():
	visible = false
	event_end.emit()
	queue_free()
