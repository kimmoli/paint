// Oil painting
// Radius;1;10

// Source: http://stackoverflow.com/a/9402041/4537127
// Anisotropic Kuwahara Filtering on the GPU
// by Jan Eric Kyprianidis <www.kyprianidis.com>

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;
uniform highp float param1;

void main (void)
{
    lowp vec2 src_size = vec2 (height, width);

    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        int radius = int(param1);
        vec2 uv = qt_TexCoord0;
        float n = float((radius + 1) * (radius + 1));

        vec3 m[4];
        vec3 s[4];
        for (int k = 0; k < 4; ++k)
        {
            m[k] = vec3(0.0);
            s[k] = vec3(0.0);
        }

        for (int j = -radius; j <= 0; ++j)
        {
            for (int i = -radius; i <= 0; ++i)
            {
                vec3 c = texture2D(source, uv + vec2(i,j) / src_size).rgb;
                m[0] += c;
                s[0] += c * c;
            }
        }

        for (int j = -radius; j <= 0; ++j)
        {
            for (int i = 0; i <= radius; ++i)
            {
                vec3 c = texture2D(source, uv + vec2(i,j) / src_size).rgb;
                m[1] += c;
                s[1] += c * c;
            }
        }

        for (int j = 0; j <= radius; ++j)
        {
            for (int i = 0; i <= radius; ++i)
            {
                vec3 c = texture2D(source, uv + vec2(i,j) / src_size).rgb;
                m[2] += c;
                s[2] += c * c;
            }
        }

        for (int j = 0; j <= radius; ++j)
        {
            for (int i = -radius; i <= 0; ++i)
            {
                vec3 c = texture2D(source, uv + vec2(i,j) / src_size).rgb;
                m[3] += c;
                s[3] += c * c;
            }
        }

        float min_sigma2 = 1e+2;
        for (int k = 0; k < 4; ++k)
        {
            m[k] /= n;
            s[k] = abs(s[k] / n - m[k] * m[k]);

            float sigma2 = s[k].r + s[k].g + s[k].b;
            if (sigma2 < min_sigma2)
            {
                min_sigma2 = sigma2;
                gl_FragColor = vec4(m[k], texture2D(source, uv).a) * qt_Opacity;
            }
        }
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
