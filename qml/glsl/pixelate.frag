// Pixelate
// Granularity;5.0;50.0

precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform highp float width;
uniform highp float height;
uniform lowp float param1;

void main()
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp vec2 uv = qt_TexCoord0.xy;
        highp vec2 tc = qt_TexCoord0;

        highp float dx = param1 / width;
        highp float dy = param1 / height;
        tc = highp vec2(dx*(floor(uv.x/dx) + 0.5), dy*(floor(uv.y/dy) + 0.5));

        gl_FragColor = texture2D(source, tc) * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
