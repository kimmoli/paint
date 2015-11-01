// Blur
// Sigma;1.0;10.0;Pixesl per side;2;10

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;
uniform lowp float param1;
uniform lowp float param2;

const float pi = 3.14159265f;

void main(void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        float sigma = param1;
        float numBlurPixelsPerSide = param2;

        // Incremental Gaussian Coefficent Calculation (See GPU Gems 3 pp. 877 - 889)
        vec3 incrementalGaussian;
        incrementalGaussian.x = 1.0f / (sqrt(2.0f * pi) * sigma);
        incrementalGaussian.y = exp(-0.5f / (sigma * sigma));
        incrementalGaussian.z = incrementalGaussian.y * incrementalGaussian.y;

        vec4 avgValue = vec4(0.0f, 0.0f, 0.0f, 0.0f);
        float coefficientSum = 0.0f;

        // Take the central sample first...
        avgValue += texture2D(source, qt_TexCoord0.xy) * incrementalGaussian.x;
        coefficientSum += incrementalGaussian.x;
        incrementalGaussian.xy *= incrementalGaussian.yz;

        // Go through the remaining 8 vertical samples (4 on each side of the center)
        for (float i = 1.0f; i <= numBlurPixelsPerSide; i++)
        {
            avgValue += texture2D(source, qt_TexCoord0.xy - i * (1.0/width) *
                                  vec2(1.0, 0.0)) * incrementalGaussian.x;
            avgValue += texture2D(source, qt_TexCoord0.xy + i * (1.0/width) *
                                  vec2(1.0, 0.0)) * incrementalGaussian.x;
            coefficientSum += 2.0 * incrementalGaussian.x;
            incrementalGaussian.xy *= incrementalGaussian.yz;
        }

        avgValue += texture2D(source, qt_TexCoord0.xy) * incrementalGaussian.x;
        coefficientSum += incrementalGaussian.x;
        incrementalGaussian.xy *= incrementalGaussian.yz;

        for (float i = 1.0f; i <= numBlurPixelsPerSide; i++)
        {
            avgValue += texture2D(source, qt_TexCoord0.xy - i * (1.0/height) *
                                  vec2(0.0, 1.0)) * incrementalGaussian.x;
            avgValue += texture2D(source, qt_TexCoord0.xy + i * (1.0/height) *
                                  vec2(0.0, 1.0)) * incrementalGaussian.x;
            coefficientSum += 2.0 * incrementalGaussian.x;
            incrementalGaussian.xy *= incrementalGaussian.yz;
        }

        gl_FragColor = (avgValue / coefficientSum) * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }

}
