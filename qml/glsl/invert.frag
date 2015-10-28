// Invert colors

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;

void main(void)
{
    highp vec4 color = texture2D(source, qt_TexCoord0.st);
    color.rgb = (1.0 - color.rgb/color.a) * color.a;

    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
        gl_FragColor = color * qt_Opacity;
    else
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
}
