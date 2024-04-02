extends NinePatchRect

signal panel_close


func _on_icon_button_pressed():
	panel_close.emit()
