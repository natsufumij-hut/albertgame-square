extends ItemScript

var cleard: Array[Vector2i] = []
var clearMap :Dictionary = {}

var tools: = CraksTool.new()
var crack: Control
var grid: Array2D
var start: bool = false
var grid_size = Vector2i(48,48)

func start_item(grid: Array2D, crack: Control):
	self.grid=grid
	self.crack = crack
	cleard.clear()
	clearMap.clear()
	$AnimationPlayer.play("play_ball")

func _physics_process(delta):
	if start:
		var gl = $Bask.global_position
		var pos = tools.calc_pos(crack,$Bask.global_position,grid_size,11)
		var pid = String.num(pos.x)+"-"+String.num(pos.y)
		var t = grid.get_cell(pos.x,pos.y)
		if t!=null and t!=0:
			print("gl",pos)
			if !clearMap.has(pid):
				clearMap[pid]=true
			else:
				cleard.append(pos)

func start_record():
	start = true

func end_item():
	print(clearMap)
	start=false
	for item in cleard:
		tools.clear_crack(crack,item.x,item.y,grid)
	item_end.emit()

func _on_icon_button_pressed():
	item_click.emit()
