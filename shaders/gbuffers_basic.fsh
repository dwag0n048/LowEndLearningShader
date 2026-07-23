#version 150

in vec2 texcoord;

uniform float frameTimeCounter;

out vec4 fragColor;

void main() {
    float wave = sin(texcoord.x * 20.0 + frameTimeCounter);

    wave = wave * 0.5 + 0.5;

    fragColor = vec4(wave, 0.0, 1.0 - wave, 0.5);
}