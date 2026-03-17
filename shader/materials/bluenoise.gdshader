shader_type canvas_item;

uniform sampler2DArray blue_noise_textures: filter_nearest, repeat_enable;

uniform vec4 light_color: source_color;
uniform vec4 dark_color: source_color;

float rand(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	COLOR = texture(TEXTURE, UV);

	// sRGB to RGB i guess...
	vec3 linear_to_RGB = pow(COLOR.rgb, vec3(2.2));
    COLOR.rgb = linear_to_RGB;

    // LUMA coefficients
	float gray = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
	
	// tiles the noise texture
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 tex_uv = mod(UV * tex_size, vec2(64.0)) / vec2(64.0);
	
	float layer = floor(rand(UV)) * 64.0;
	vec4 blue_noise = texture(blue_noise_textures, vec3(tex_uv, layer));
	vec3 new_color = step(0.5, gray + (blue_noise - 0.5)).rgb;
	
    COLOR.rgb = (new_color == vec3(1.0)) ? light_color.rgb : dark_color.rgb;
}