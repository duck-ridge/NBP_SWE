shader_type canvas_item;

uniform float gray_strength : hint_range(0.0, 1.0); // 控制灰度滤镜强度（0 = 原色, 1 = 完全灰度）
uniform float u_pixel_size : hint_range(90.0, 100.0); // 控制像素化程度（值越大，像素块越大）

void fragment() {
    float grid_size = floor(u_pixel_size);
    vec2 grid_uv = round(UV * grid_size) / grid_size;

    vec4 input_color = texture(TEXTURE, grid_uv);
    
    float color_average = (input_color.r + input_color.g + input_color.b) / 3.0;
    vec4 grayscale_color = vec4(color_average, color_average, color_average, input_color.a);

    COLOR = mix(input_color, grayscale_color, gray_strength);
}
