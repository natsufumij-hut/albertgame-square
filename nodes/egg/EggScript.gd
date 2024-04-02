class_name EggScript
extends Control

signal egg_end

# 开始彩蛋播放
func start_egg():
	var anim: = $AnimationPlayer as AnimationPlayer
	anim.play("egg")

func end_egg():
	egg_end.emit()
	visible = true
	queue_free()
