class_name IconButton
extends TextureButton
var down: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(self._on_button_down)
	button_up.connect(self._on_button_up)
	pivot_offset = size / 2

func _on_button_down():
	if !down:
		scale = scale * 1.2
		#print("scale",scale)
		down=true

func _on_button_up():
	if down:
		scale = scale / 1.2
		#print("scale",scale)
		down= false

