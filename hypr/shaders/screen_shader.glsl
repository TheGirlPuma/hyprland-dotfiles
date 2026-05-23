#version 320 es

precision highp float;

uniform sampler2D tex;

out vec4 FragColor;

void main() {
    vec2 uv = gl_FragCoord.xy / vec2(textureSize(tex, 0));
    FragColor = texture(tex, uv);
}
