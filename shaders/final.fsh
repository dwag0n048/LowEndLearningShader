#version 150

uniform sampler2D colortex0;
uniform float frameTimeCounter;

in vec2 texcoord;

out vec4 fragColor;

vec2 HeatDistortion(vec2 uv)
{
    uv.x += sin(frameTimeCounter * 5.0 + texcoord.y * 80.0) * 0.003;

    return uv;
}

vec3 ApplyBrightness(vec3 color)
{
    return color;
}

void main() {
    vec2 uv = texcoord;
    uv = HeatDistortion(uv);
    vec3 color = texture(colortex0, uv).rgb;

    fragColor = vec4(color, 1.0);
}