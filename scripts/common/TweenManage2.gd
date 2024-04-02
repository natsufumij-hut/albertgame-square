class_name TweenManage2

signal all_end

var record: Dictionary

func register(id: String):
	record[id]="OK"

func end(id: String):
	record.erase(id)
	if record.is_empty():
		all_end.emit()
