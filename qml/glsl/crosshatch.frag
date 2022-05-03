// crosshatch
// Luminosity;0.3;1.0

precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform highp float param1;

void main()
{
    float lum = length(texture2D(source, qt_TexCoord0.xy).rgb);

    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);

    if (lum < 1.00) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }

    if (lum < 0.75) {
        if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }

    if (lum < 0.50) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }

    if (lum < 0.3) {
        if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
}
