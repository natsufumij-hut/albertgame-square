extends CrackEvent

var tools := CraksTool.new()

# 调用此方法结束事件,anim动画结束的回调，实现自己的事件后置动作
func event_call_end():
	if result.is_empty():
		call_end()
		return
	var destOne := result[0] as Vector2i
	var tween = craks.get_tree().create_tween()
	var dest := tools.get_cell(craks,destOne.x,destOne.y) as CrackScript
	var one := $Ice as Control
	var lier := $TextureRect2 as Control
	var destPos := dest.global_position +  Vector2((dest.crack_size-1)*24,0)
	var dis = destPos.distance_to(one.global_position)
	var audio := $AudioStreamPlayer2D as AudioStreamPlayer2D
	var times = dis / 600.0
	one.visible = true
	tween.tween_property(one, "position", destPos , times)
	tween.set_parallel(true).tween_property(one, "scale", Vector2(0.15,0.15) , times)
	tween.set_parallel(false).tween_callback(self.patch_lier)
	tween.set_parallel(false).tween_property(lier,"visible",true,0)
	tween.tween_property(audio,"playing",true,0)
	tween.tween_property(one, "position", destPos , 0.2)
	tween.tween_property(one, "self_modulate", Color(255,255,255,0), 0.5).set_delay(1)
	tween.tween_property(lier, "self_modulate", Color(255,255,255,0) , 0.3)
	tween.tween_callback(self.patch_snow)
	tween.tween_callback(self.call_end)
	tween.play()
	
# 覆盖此方法实现多态,开始事件之前计算
func event_before_start() -> Array[Vector2i]:
	var rows = grid.data.size()
	var columns = grid.get_row(0).size()
	var i = rows-1
	while i>=0:
		var j = 0
		while j<columns:
			var t = grid.get_cell(i,j)
			if t!=0:
				var item := tools.get_cell(craks,i,j) as CrackScript
				if item.alive==0:
					item.alive+=1
					return [Vector2i(i,j)]
				j+=item.crack_size
			else:
				j+=1
		i-=1
	return []

func call_end():
	event_end.emit()
	queue_free()

func patch_lier():
	var one := $Ice as Control
	var lier := $TextureRect2 as Control
	lier.position = one.global_position - Vector2(12,12)


func patch_snow():
	var snow := $Patch as TextureRect
	remove_child(snow)
	snow.position = Vector2.ZERO
	var destOne := result[0] as Vector2i
	var dest = tools.get_cell(craks,destOne.x,destOne.y) as CrackScript
	snow.size.x = 48 * dest.crack_size
	dest.add_child(snow)
	snow.visible = true
	snow.name = "Event"

