class_name TweenManage

signal all_end

var record: Dictionary
var id: String

func _init(id: String,record: Dictionary):
	self.record=record
	self.id=id
	record[id]="OK"

func end():
	record.erase(id)
	if record.is_empty():
		all_end.emit()
