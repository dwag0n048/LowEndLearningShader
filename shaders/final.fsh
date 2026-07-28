#version 150

uniform sampler2D colortex0;
uniform float frameTimeCounter;

in vec2 texcoord;

out vec4 fragColor;

const float HEAT_STRENGTH = 0.003;
const float HEAT_SPEED = 5.0;
const float HEAT_FREQUENCY = 80.0;
const float HEAT_SECOND_SPEED = 1.7;
const float HEAT_SECOND_FREQUENCY = 0.4;

vec2 HeatDistortion(vec2 uv)
{
    float wave1 = sin(frameTimeCounter * HEAT_SPEED + uv.y * HEAT_FREQUENCY);
    float wave2 = sin(frameTimeCounter * (HEAT_SPEED * HEAT_SECOND_SPEED) + uv.y * (HEAT_FREQUENCY * HEAT_SECOND_FREQUENCY));
    float distortion = (wave1 + wave2) * 0.5;
    float mask = smoothstep(0.2, 1.0, uv.y);
    uv.x += distortion * HEAT_STRENGTH * mask;

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