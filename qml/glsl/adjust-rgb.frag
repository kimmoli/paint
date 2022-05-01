// Adjust RGB
// Red;-1.0;1.0;Green;-1.0;1.0;Blue;-1.0;1.0

precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float param1;
uniform lowp float param2;
uniform lowp float param3;

void main(void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp vec4 color = texture2D(source, qt_TexCoord0.st);
        color.rgb = color.rgb/color.a;
        color.rgb = highp vec3(clamp(color.r + param1, 0.0, 1.0),
                               clamp(color.g + param2, 0.0, 1.0),
                               clamp(color.b + param3, 0.0, 1.0)) * color.a;

        gl_FragColor = color * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
