class_name Star
extends Control

@onready var label:= $Num as Label

func _ready():
	label.text = String.num(GameDataLoader.localData.tai)
	GlobalSignal.update_tai.connect(self.update_tai)

func update_tai(tai: int):
	label.text = String.num(tai)
