shader_type canvas_item;
uniform float amount : hint_range(0.0, 1.0) = 1.0;
void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	float grayscale_value = dot(base_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 grayscale_color = vec3(grayscale_value);
	COLOR.rgb = mix(base_color.rgb, grayscale_color, amount); 
	COLOR.a = base_color.a;
}