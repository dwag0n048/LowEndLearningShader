#version 150

in vec2 texcoord;

uniform float frameTimeCounter;
uniform sampler2D gtexture;

out vec4 fragColor;

void main() {
    vec2 uv = texcoord;
    vec3 color = mix(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, 0.0, 1.0),
        abs(sin(frameTimeCounter))
    );

    fragColor = vec4(color, 1.0);
}