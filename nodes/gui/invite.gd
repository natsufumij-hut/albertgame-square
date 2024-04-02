extends Control

signal invite_one(id: String)

func _on_closepanel_panel_close():
	$Closepanel/LineEdit.text = ""
	visible = false


func _on_ok_pressed():
	var text := $Closepanel/LineEdit.text as String
	text = text.strip_edges()
	if text.length() > 0:
		invite_one.emit(text)
		print("邀请,",text)
		_on_closepanel_panel_close()
		
