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
const float WATER_AMBIENT = 0.40;

struct WaterData
{
    vec2 uv;
    float waves;
};

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

float GetWave(vec2 uv)
{
    float wave1 = sin(uv.x * 30.0 + frameTimeCounter * 3.0);
    float wave2 = sin((uv.x + uv.y) * 18.0 - frameTimeCounter * 2.1);
    float wave3 = sin((uv.x - uv.y) * 22.0 + frameTimeCounter * 1.6);

    return (wave1 + wave2 + wave3) / 3.0;
}

WaterData WaterWave(vec2 uv)
{    
   float waves = GetWave(uv);

    uv.y += waves * WATER_STRENGTH;

    WaterData data;

    data.uv = uv;
    data.waves = waves;

    return data;
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
    WaterData water = WaterWave(uv);
    uv = water.uv;

    float offset = 0.01;

    float left = GetWave(texcoord - vec2(offset, 0.0));
    float right = GetWave(texcoord + vec2(offset, 0.0));
    float down = GetWave(texcoord - vec2(0.0, offset));
    float up = GetWave(texcoord + vec2(0.0, offset));

    float slopeX = right - left;
    float slopeY = up - down;

    vec3 normal = normalize(vec3(-slopeX * 5.0, 1.0, -slopeY * 5.0));

    // Sampling
    vec3 color = texture(colortex0, uv).rgb;

    float highlight = smoothstep(0.8, 1.0, water.waves);
    float fakeFresnel = pow(1.0 - uv.y, 5.0);

    // Color Stage
    color = ApplyBrightness(color);
    color = ApplyContrast(color);
    color = ApplySaturation(color);
    color += vec3(0.8, 0.9, 1.0) * highlight * fakeFresnel * 0.15;

    vec3 lightDir = normalize(vec3(0.4, 1.0, 0.3));
    float diffuse = max(dot(normal, lightDir), 0.0);
    float light = WATER_AMBIENT + diffuse * (1.0 - WATER_AMBIENT);


    vec3 waterColor = texture(colortex0, uv).rgb;
    // Output
    fragColor = vec4(waterColor * light, 1.0);
}