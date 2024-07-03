#ifdef GL_ES
precision mediump float;
#endif
varying vec3 vPosition;
varying vec3 vFaceCenter;

// viewMatrix: 4x4 matrix that moves the world space to the camera space

void main() {
    vPosition = position;

    vFaceCenter = position * (1.0 - uv.x - uv.y) + position * uv.x + position * uv.y;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}