#version 150

uniform sampler2D gtexture;

in vec2 texcoord;
out vec4 fragColor;

void main() {
    vec3 color = texture(gtexture, texcoord).rgb;
    fragColor = vec4(1.0, 0.0, 1.0, 1.0);
}