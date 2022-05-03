// Warhol

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;

void main(void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp vec4 orig = texture2D(source, qt_TexCoord0.xy);
        highp vec3 col = orig.rgb/orig.a;
        highp float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
        y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
        if (y == 0.5)
            col = vec3(0.8, 0.0, 0.0);
        else if (y == 1.0)
            col = vec3(0.9, 0.9, 0.0);
        else
            col = vec3(0.0, 0.0, 0.0);

        gl_FragColor = vec4(col.rgb * orig.a, orig.a) * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
