attribute vec4 position;
attribute vec4 color;

varying vec4 v_color;

uniform mat4 mvp;

void main() {
    gl_Position = mvp * position;
    v_color = color;
}