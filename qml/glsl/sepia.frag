// Sepia
// Intensity;0.0;1.0

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform highp float width;
uniform highp float height;
uniform lowp float param1;

const lowp mat4 colorMatrix = mat4( 0.3588, 0.7044, 0.1368, 0,
                                    0.2990, 0.5870, 0.1140, 0,
                                    0.2392, 0.4696, 0.0912 ,0,
                                    0,      0,      0,      0);

void main()
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        lowp vec4 textureColor = texture2D(source, qt_TexCoord0.st);
        lowp vec4 outputColor = textureColor * colorMatrix;

        outputColor = (param1 * outputColor) + ((1.0 - param1) * textureColor);

        gl_FragColor = outputColor * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
