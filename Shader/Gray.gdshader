shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.3;


void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	float avg = (bg.r + bg.g + bg.b)/3.0;
	COLOR = vec4(avg, avg, avg, 1.0);
	
	
	
}

