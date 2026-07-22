#version 150

out vec4 fragColor;

void main() {
    fragColor = vec4(1.0, 0.4, 0.2, 1.0);
    fragColor.b = 1.0;
    fragColor.g *= 0.5;
    fragColor.r -= 0.3;
}