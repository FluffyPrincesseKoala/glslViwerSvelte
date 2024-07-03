// uniform vec3 u_camera; // possition of the camera

// uniform vec3 u_pos;
vec3 transformDirection(in vec3 dir, in mat4 matrix) {
	return normalize((matrix * vec4(dir, 0.0)).xyz);
}

void main() {
	// bend the vertices to make a sphere

	gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}