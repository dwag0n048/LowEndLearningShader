#version 150

in vec2 texcoord;

uniform float frameTimeCounter;

out vec4 fragColor;

void main() {
    vec2 uv = texcoord;

    uv.y += sin(uv.x * 20.0 + frameTimeCounter) * 0.10;

    float wave = sin(uv.x * 20.0 + frameTimeCounter) * sin(uv.y * 12.0 + frameTimeCounter * 0.7); 

    wave = wave * 0.5 + 0.5;

    fragColor = vec4(wave, 0.0, 1.0 - wave, 1.0);
}