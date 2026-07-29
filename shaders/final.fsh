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

const float WATER_STRENGTH = 0.006;

vec2 HeatDistortion(vec2 uv)
{
    float wave1 = sin(frameTimeCounter * HEAT_SPEED + uv.y * HEAT_FREQUENCY);
    float wave2 = sin(frameTimeCounter * (HEAT_SPEED * HEAT_SECOND_SPEED) + uv.y * (HEAT_FREQUENCY * HEAT_SECOND_FREQUENCY));
    float distortion = (wave1 + wave2) * 0.5;
    float flippedY = 1.0 - uv.y;
    float mask = smoothstep(0.2, 1.0, flippedY);
    uv.x += distortion * HEAT_STRENGTH * mask;

    return uv;
}

vec2 WaterWave(vec2 uv)
{
    float wave1 = sin(uv.x * 30.0 + frameTimeCounter * 3.0);
    float wave2 = sin((uv.x + uv.y) * 18.0 - frameTimeCounter * 2.1);
    float wave3 = sin((uv.x - uv.y) * 22.0 + frameTimeCounter * 1.6);

    float waves = (wave1 + wave2 + wave3) / 3.0;

    uv.y += waves * WATER_STRENGTH;

    return uv;
}

vec3 ApplyBrightness(vec3 color)
{
    return color;
}

vec3 ApplyContrast(vec3 color)
{
    return color;
}

vec3 ApplySaturation(vec3 color)
{
    return color;
}

void main() {
    vec2 uv = texcoord;

    // UV Stage
    uv = HeatDistortion(uv);
    uv = WaterWave(uv);

    // Sampling
    vec3 color = texture(colortex0, uv).rgb;

    // Color Stage
    color = ApplyBrightness(color);
    color = ApplyContrast(color);
    color = ApplySaturation(color);

    // Output
    fragColor = vec4(color, 1.0);
}