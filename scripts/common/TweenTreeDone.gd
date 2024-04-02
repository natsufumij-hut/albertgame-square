class_name TweenTreeDone

var record: Dictionary
var id: String
var model: String
var tree: AnimationTree

func _init(model: String, id: String,record: Dictionary,tree: AnimationTree):
	self.record=record
	self.id=id
	self.tree=tree
	self.model=model

func end():
	record.erase(id)
	if record.is_empty():
		tree.set(model,true)
		print("set model ",model)
