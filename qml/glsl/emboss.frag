// Emboss


precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;

void main(void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp vec4 colorin = texture2D(source, qt_TexCoord0.st);

        float ResS = width;
        float ResT = height;
        vec3 irgb = colorin.rgb/colorin.a;
        vec2 stpp = vec2(1./ResS, 1./ResT);
        vec3 c00 = texture2D(source, qt_TexCoord0.st ).rgb;
        vec3 cp1p1 = texture2D(source, qt_TexCoord0.st + stpp ).rgb;
        vec3 diffs = c00 - cp1p1;
        float max = diffs.r;
        if ( abs(diffs.g) > abs(max) ) max = diffs.g;
        if ( abs(diffs.b) > abs(max) ) max = diffs.b;
        float gray = clamp( max + 0.5, 0.0, 1.0 );
        vec3 color = vec3( gray, gray, gray );

        gl_FragColor = vec4( color, 1. ) * colorin.a * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
