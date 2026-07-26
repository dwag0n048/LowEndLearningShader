#version 150

uniform sampler2D colortex0;

in vec2 texcoord;

out vec4 fragColor;

void main() {
    vec3 color = texture(colortex0, texcoord).rgb;
    color *= 0.5;
    fragColor = vec4(color, 1.0);
}