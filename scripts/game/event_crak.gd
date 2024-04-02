## 事件方块
class_name EventCrak

signal put_event(event_scene: Control)
signal wait_event()

enum CrakEventType {
	SNOW,
	ICE,
	INK
}

var eventDict: Dictionary = {
	CrakEventType.SNOW: "SnowEvent"
}

var columns: int = 9
var rows: int = 11
var craks: Control
var pks:Array[PackedScene]
var grid: Array2D
var tree: AnimationTree

func _init(col: int, row: int, craks: Control, pkg: Array[PackedScene], grid: Array2D, tree: AnimationTree):
	self.columns=col
	self.rows=row
	self.craks=craks
	self.pks=pkg
	self.grid=grid
	self.tree=tree

# 等待事件
func wait_call_event():
	wait_event.emit()

var event: CrakEventType
# 设置事件
func set_event(ev: CrakEventType):
	event = ev
# 开始事件
func start_event():
	var event_scene :CrackEvent = load_event(eventDict[event]) as CrackEvent
	event_scene.event_end.connect(self.event_end_this)
	put_event.emit(event_scene)

# 导入事件
func load_event(name_id: String):
	var path = "res://nodes/event/"+name_id+".tscn"
	return load(path)

func event_end_this():
	#tree.set("")
	pass
