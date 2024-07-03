#ifdef GL_ES
precision mediump float;
#endif
uniform vec3 vPosition; // position of the vertex
varying vec3 vFaceCenter; // face center

uniform float u_time;
// uniform mat4 viewMatrix;

// palette function
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

float circle(vec2 uv, vec2 center, float radius, float blur) {
    float d = distance(uv, center);
    return smoothstep(radius, radius + blur, d);
}

void main() {
    vec3 centerPosition = normalize(vFaceCenter);

    // face index rotation matrix
    vec3 finalColor = vec3(1);
    float circles;
    // rotate the view position

    float d = length(centerPosition.xz);
    d = fract(d * 10.0) - sin(u_time) * 0.5;
    float p = 0.5;
    for(float i = 0.0; i < .80; i += 0.1) {
        vec2 uv = vFaceCenter.xy / 100.0;
        uv.y += i / 2.0;
        uv.x += i * 0.5;
    }

        // rotate the normal coordinates
    finalColor = mix(finalColor, palette(circles, vec3(0.7804, 0.1804, 0.1804), vec3(0.4588, 0.5725, 0.0471), vec3(1.0, 1.0, 1.0), vec3(0.2275, 0.0078, 0.0078)), circles);

    // finalColor = mix(finalColor, palette(circles, vec3(0.7804, 0.1804, 0.1804), vec3(0.4588, 0.5725, 0.0471), vec3(1.0, 1.0, 1.0), vec3(0.9686, 0.9686, 0.9686)), circles);

    // add other circles or shapes on other faces

    gl_FragColor = vec4(finalColor, 1.0);
}