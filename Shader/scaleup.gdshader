shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec2 center = vec2(0.5, 0.5); // 放大区域的中心
uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.3; // 放大区域的半径
uniform float zoom_factor: hint_range(1.0, 5.0, 0.1) = 2.0; // 放大倍数

void fragment() {
    vec2 uv = SCREEN_UV;
	
	vec2 resolution = 1.0/TEXTURE_PIXEL_SIZE;
	vec2 aspect_uv = uv;
	aspect_uv.x *= resolution.x / resolution.y;
	
	
    // 计算当前像素到放大中心的距离
    float dist = distance(aspect_uv, center);

    if (dist < radius) {
        // 如果在放大区域内，调整UV坐标
        vec2 direction = aspect_uv - center;  // 获取从中心到当前像素的方向
        aspect_uv = center + direction / zoom_factor; // 缩小方向向量以实现放大效果
    }

    // 采样纹理并设置颜色
    vec4 color = texture(SCREEN_TEXTURE, aspect_uv);
    COLOR = color;
}
