#version 150

in vec2 texcoord;

out vec4 fragColor;

void main() {
    fragColor = vec4(texcoord.x, texcoord.y, 0.0, 1.0);
}