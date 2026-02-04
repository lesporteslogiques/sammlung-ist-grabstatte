shader_type spatial;
uniform sampler2D texture_x: source_color, repeat_enable;

void vertex() {
	VERTEX.x = VERTEX.x + cos(TIME * 1.0 + VERTEX.y) * (VERTEX.y / 10.0) * smoothstep(2.0,20.0,VERTEX.y);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 vertex = INV_VIEW_MATRIX * vec4(VERTEX,1.0);
	vec3 normal = normalize((INV_VIEW_MATRIX * vec4(VERTEX,0.0)).xyz);
	vec3 adjusted_normal = normalize(normal);
	vec3 weights = adjusted_normal / (adjusted_normal.x + adjusted_normal.y + adjusted_normal.z) * 3.0;
	
	vec2 uv_x = vertex.zy * weights.x;
	vec2 uv_y = vertex.xz * weights.y;
	vec2 uv_z = vertex.xy * weights.z;
	
	vec3 color_x = texture(texture_x, uv_x).rgb;
	vec3 color_y = texture(texture_x, uv_y).rgb;
	vec3 color_z = texture(texture_x, uv_z).rgb;
	//ALBEDO = vec3(1.0,smoothstep(0.0,50.0,vertex.y),0.0);
	ALBEDO = (color_x + color_y + color_z) / 3.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
