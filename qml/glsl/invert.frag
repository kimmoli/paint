// Invert colors

uniform sampler2D source;
varying highp vec2 qt_TexCoord0;

void main(void)
{
    lowp vec4 c = texture2D(source, qt_TexCoord0.xy);
    gl_FragColor = lowp vec4(1.0 - c.r, 1.0 - c.g, 1.0 - c.b, c.a);
}
