shader_type canvas_item;

// 纹理尺寸
uniform vec2 texture_size;
// 圆半径
uniform float radius;

bool check(vec2 texCoord){
	vec2 pos = vec2(texCoord.x * texture_size.x,(1.0-texCoord.y) * texture_size.y);
	float deltaX = pos.x - texture_size.x * 0.5;
	float deltaY = pos.y - texture_size.y * 0.5;
	float radiusPow = pow(radius,2);
	float pow_value = pow(deltaX,2) + pow(deltaY,2);
	return pow_value <= radiusPow;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 o = texture(TEXTURE,UV);
	if(!check(UV)){
		o *= vec4(0,0,0,0);
	}
	COLOR = o;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
