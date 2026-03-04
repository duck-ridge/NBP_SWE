shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float power: hint_range(0.1, 10.0, 0.01) = 1.0;
uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.3;

void fragment() {
	vec2 uv = UV;
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	
	//复制 uv 坐标，保留原始的纹理坐标，以便在后续修改其比例时不影响原始 UV。
	//变量 aspect_uv 将用于保持正确的宽高比例。
	vec2 aspect_uv = uv;
	
	//保证长宽比，这样可以确保 X 方向拉伸，使图像看起来不变形
	//此时aspect_uv.y则是原先的uv，每个像素都不同
	aspect_uv.x *= resolution.x / resolution.y;
	
	vec2 eye_uv = center;
	eye_uv.x *= resolution.x / resolution.y;
	
	float dist = distance(eye_uv, aspect_uv);
	
	//原视频的wrap拼错了
	float wrap = pow(dist/radius, 5.0);
	float mag_factor = pow(wrap, 1.0/power);
	if (dist < radius)
	{
		uv += mag_factor * (center - uv);
	}
	COLOR = texture(TEXTURE, uv);
}