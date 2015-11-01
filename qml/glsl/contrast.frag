// Contrast, Brightness, Saturation
// Contrast;0.0;2.0;Brightness;0.0;2.0;Saturation;0.0;2.0

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

        const highp vec3 contrast = vec3(0.5);
        const highp vec3 brightness = vec3(0.0);
        const highp vec3 W = vec3( 0.2125, 0.7154, 0.0721 );
        highp vec3 luminance = vec3( dot(color.rgb, W));

        gl_FragColor = vec4( mix ( luminance, mix( contrast, mix( brightness, color.rgb, param2), param1), param3), color.a ) * color.a * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
