extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var mater = material as ShaderMaterial
	mater.set_shader_parameter("texture_size",size)
	mater.set_shader_parameter("radius",size.x/2)

