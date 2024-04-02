extends CrackEvent

var tools := CraksTool.new()

# 调用此方法结束事件,anim动画结束的回调，实现自己的事件后置动作
func event_call_end():
	if result.is_empty():
		call_end()
		return
	var destOne := result[0] as Vector2i
	var tween = craks.get_tree().create_tween()
	var dest = tools.get_cell(craks,destOne.x,destOne.y)
	var one := $TextureRect as Control
	var destPos := dest.global_position as Vector2
	var dis = destPos.distance_to(one.global_position)
	var times = dis / 300.0
	tween.tween_property(one, "position", destPos , times)
	tween.tween_property(one, "position", destPos , 0.2)
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
	
func patch_snow():
	var snow := $TextureRect as TextureRect
	remove_child(snow)
	snow.position = Vector2.ZERO
	var destOne := result[0] as Vector2i
	var tween = craks.get_tree().create_tween()
	var dest = tools.get_cell(craks,destOne.x,destOne.y)
	dest.add_child(snow)
	snow.name = "Event"
