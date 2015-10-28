// Adjust gamma
// Gamma;0.1;3.0

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform highp float param1;

void main(void)
{
    highp vec4 originalColor = texture2D(source, qt_TexCoord0.st);
    originalColor.rgb = originalColor.rgb / max(1.0/256.0, originalColor.a);
    highp vec3 adjustedColor = pow(originalColor.rgb, vec3(param1));

    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
        gl_FragColor = vec4(adjustedColor * originalColor.a, originalColor.a) * qt_Opacity;
    else
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
}
