// Jolla glasseffect
// Mix;0.0;2.0
// imageSource;image://paintIcons/graphic-shader-texture

precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
uniform sampler2D imageSource;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;
uniform lowp float imageSourceWidth;
uniform lowp float imageSourceHeight;
uniform lowp float param1;

void main()
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        vec2 xy = qt_TexCoord0.xy;
        vec2 phase = fract(xy / vec2(imageSourceWidth/width, imageSourceHeight/height));
        vec4 outColor = texture2D(imageSource, phase);
        gl_FragColor = mix( texture2D(source, qt_TexCoord0), outColor, param1) * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
