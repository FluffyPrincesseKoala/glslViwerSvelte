// #ifdef GL_ES
// precision mediump float;
// #endif
// uniform vec2 resolution;
// uniform float time;
// uniform vec2 camera;
// uniform vec3 u_camera;
// // uniform vec3 u_rotation;

// /* Color palette */
// #define BLACK           vec3(0.0, 0.0, 0.0)
// #define WHITE           vec3(1.0, 1.0, 1.0)
// #define RED             vec3(1.0, 0.0, 0.0)
// #define GREEN           vec3(0.0, 1.0, 0.0)
// #define BLUE            vec3(0.0, 0.0, 1.0)
// #define YELLOW          vec3(1.0, 1.0, 0.0)
// #define CYAN            vec3(0.0, 1.0, 1.0)
// #define MAGENTA         vec3(1.0, 0.0, 1.0)
// #define ORANGE          vec3(1.0, 0.5, 0.0)
// #define PURPLE          vec3(1.0, 0.0, 0.5)
// #define LIME            vec3(0.5, 1.0, 0.0)
// #define ACQUA           vec3(0.0, 1.0, 0.5)
// #define VIOLET          vec3(0.5, 0.0, 1.0)
// #define AZUR            vec3(0.0, 0.5, 1.0)

// #define PURPLERAINA
// #define PURPLERAINB
// #define PURPLERAINC
// #define PURPLERAINF

// float sdCircle(vec2 p, float r) {
// 	return length(p) - r;
// }

// mat2 rot(float a) {
// 	float c = cos(a);
// 	float s = sin(a);
// 	return mat2(c, -s, s, c);
// }

// float sdBox(in vec2 p, in vec2 b) {
// 	vec2 d = abs(p) - b;
// 	return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
// }

// vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d) {
// 	return a + b * cos(6.28318 * (c * t + d));
// }

// vec3 osilate(vec3 x, float depth) {
// 	return x * sin(depth * time);
// }

// void main() {
// 	vec2 uv = (gl_FragCoord.xy * 2. - resolution.xy) / resolution.y;
// 	// uv *= rot(u_rotation.z);
//     // rotate the whole thing
//     // uv *= rot(0.1 * time);
// 	vec3 finalColor = vec3(0.0);
// 	// float iMax = 5.0;
// 	// float jMax = 5.0;
// 	float iMax = mix(1.0, 15.0, camera.x / resolution.x);
// 	float jMax = mix(1.0, 15.0, camera.y / resolution.y);

// 	for(float i = 0.0; i < iMax; i++) {
// 		vec3 color = vec3(0.0);
// 		color = vec3(0.0, 1.0, 1.0);

// 		float lep = 0.1 * sin(0.1 * log2(time));
// 		float lop = 0.1 + 0.1 * tan(-cos(0.1 * time));
//         //move the triangle down
// 		float movOffset = 0.0 + lep * i;
// 		vec2 p = vec2(lop, movOffset);
// 		uv -= p;

//         // factal triangle
// 		for(float j = 0.; j < jMax; j++) {
// 			uv = abs(uv) - 0.5;
// 			p = abs(p) - 0.5;
// 			float base = sdCircle(p, 0.2 - 0.1 * sin(1. * time));
// 			color = palette(base, osilate(vec3(-0.129, 0.044, 0.594), 0.1), vec3(0.745, 0.741, 0.432), vec3(0.136, 1.230, 1.042), osilate(vec3(3.899, 2.618, 0.764), .1));
// 		}
//         // get center of the triangle
// 		vec2 possition = (uv - p);
// 		possition = rot(0.1 * time) * possition;
//         // make a box
// 		float border = sdBox(possition, vec2(0.2 + 0.1 * sin(0.5 * time)));
// 		border = abs(border);
// 		border = pow(0.015 / border, 1.2);

//         // waves from border
// 		border += 0.1 * sin(0.1 * time + 6.28318 * border);

//         // change color of each triangle

//         // make color less bright
// 		color *= 0.1 + border * 0.5;

// 		finalColor += border * color;
// 	}
// 	gl_FragColor = vec4(finalColor, 1.0);

// }
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform float time;
uniform vec2 camera;
uniform vec2 u_mouse;
// sd sphere
float sdSphere(vec3 p, float s) {
	return length(p) - s;
}

float sdBox(vec3 p, vec3 b) {
	vec3 q = abs(p) - b;
	return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

vec4 opElongate(in vec3 p, in vec3 h) {
    //return vec4( p-clamp(p,-h,h), 0.0 ); // faster, but produces zero in the interior elongated box

	vec3 q = abs(p) - h;
	return vec4(max(q, 0.0), min(max(q.x, max(q.y, q.z)), 0.0));
}

float map(vec3 p) {
	float d = length(p) - 1.0;
	return d;
}

float opOnion(in float sdf, in float thickness) {
	return abs(sdf) - thickness;
}

float smin(float a, float b, float k) {
	float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
	return mix(b, a, h) - k * h * (1.0 - h);
}

float dot2(in vec2 v) {
	return dot(v, v);
}
float dot2(in vec3 v) {
	return dot(v, v);
}
float ndot(in vec2 a, in vec2 b) {
	return a.x * b.x - a.y * b.y;
}

vec3 rot3D(vec3 p, vec3 axis, float angle) {
	return mix(dot(axis, p) * axis, p, cos(angle)) + cross(axis, p) * sin(angle);
}

float opUnion(float d1, float d2) {
	return min(d1, d2);
}
float opSubtraction(float d1, float d2) {
	return max(-d1, d2);
}
float opIntersection(float d1, float d2) {
	return max(d1, d2);
}
float opXor(float d1, float d2) {
	return max(min(d1, d2), -max(d1, d2));
}
mat2 rot(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat2(c, -s, s, c);
}

float opSmoothUnion(float d1, float d2, float k) {
	float h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
	return mix(d2, d1, h) - k * h * (1.0 - h);
}

float opSmoothSubtraction(float d1, float d2, float k) {
	float h = clamp(0.5 - 0.5 * (d2 + d1) / k, 0.0, 1.0);
	return mix(d2, -d1, h) + k * h * (1.0 - h);
}

float opSmoothIntersection(float d1, float d2, float k) {
	float h = clamp(0.5 - 0.5 * (d2 - d1) / k, 0.0, 1.0);
	return mix(d2, d1, h) + k * h * (1.0 - h);
}

float map2(vec3 p) {
    // vec3 SpherePos = vec3(sin(time) * 1.5, 0, 0);
	vec3 SpherePos = vec3(1.5, 0, 0);

    // rotate sphere from center of the scene
	SpherePos.xy *= rot(.5);

	float Sphere = sdSphere(p - SpherePos, .5);
	float Sphere2 = sdSphere(p + SpherePos, .5);

	vec3 q = p;

    // q.zx *= rot(time * .05);
    // q.xy *= rot(time * .5);
    // q.yz *= rot(time * .25);

	// q.yzx = (fract(q.yzx + time * .5) - .5);

    // rotate boxes
	// q.xy *= rot(time);
	// q.yz *= rot(time * .5);

	float Box = sdBox(q, vec3(.1));

	float ground = p.y + 3.75;

    //merge spheres
    // float Spheres = min(Sphere, Sphere2);
	float Spheres = smin(Sphere, Sphere2, 2.);

	float boxSphereMix = smin(Spheres, Box, .5);
	// float boxSphereMix = opSubtraction(Box, Sphere);
	// float boxSphereMix = opUnion(Spheres, Box);
	// float boxSphereMix = opIntersection(Box, Sphere);
    // float boxSphereMix = opXor(Box, Sphere);
	// float boxSphereMix = opSmoothUnion(Sphere, Box, 1.);
	// float boxSphereMix = opSmoothSubtraction(Sphere, Box, 1.);

	// return min(ground, boxSphereMix);
	return smin(ground, boxSphereMix, 2.);
    // return boxSphereMix;
    // return opSubtraction(boxSphereMix, ground);
}

void main() {
	vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / resolution.y;
	// vec2 mouse = (camera.xy * 2.0 - resolution.xy) / resolution.y;
	vec2 mouse = (u_mouse.xy * 2.0 - resolution.xy) / resolution.y;

    //smooth camera zoom
	mouse *= 1.0 - exp(-abs(mouse) * 2.0);

	vec3 ro = vec3(0, 0, -3);
	uv *= .75; // camera zoom out
	vec3 rd = normalize(vec3(uv, 1.0));
	vec3 col = vec3(0);

	float t = 0.0;

    // acctivate camera rotation on click

    // vertical camera rotation prevents camera from going upside down
	ro.yz *= rot(mouse.y * 1.5);
	rd.yz *= rot(mouse.y * 1.5);

    // horizontal camera rotation
	ro.xz *= rot(-mouse.x * 1.5);
	rd.xz *= rot(-mouse.x * 1.5);

    // ray marching
	for (int i = 0; i < 100; i++) {
		vec3 p = ro + rd * t;

		p.yx *= rot(.5);

		float d = map2(p);

		t += d;
        // col = vec3(i) / 80.0;
		if (d < 0.001)
			break;
		if (t > 1000.0)
			break;
	}

	col = vec3(t * 0.02);

    // diffuse light from camera
	vec3 lightDir = normalize(vec3(0, 0, 1));
	float diffuse = max(4.0, dot(rd, lightDir));
	col *= diffuse;

	gl_FragColor = vec4(col, 1);
}