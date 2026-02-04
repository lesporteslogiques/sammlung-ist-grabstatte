shader_type spatial;

void vertex() {
	VERTEX.x = VERTEX.x + cos(TIME * 10.0 + VERTEX.y * 0.5) * VERTEX.y / 50.0;
}

void fragment() {
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
