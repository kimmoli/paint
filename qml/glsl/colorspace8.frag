// Change colorspace, 8 colors
// Pre brightness;0.0;2.0


uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float param1;

void main (void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        // Adapted from: https://github.com/BradLarson/GPUImage/blob/master/framework/Source/GPUImageCGAColorspaceFilter.m

        highp vec3 color = texture2D(source, qt_TexCoord0).rgb/texture2D(source, qt_TexCoord0).a;

        const highp vec3 brightness = vec3(0.0);
        color = mix(brightness, color, param1);

        mediump vec3 colorBlack   = vec3(0.0);
        mediump vec3 colorWhite   = vec3(1.0);
        mediump vec3 colorRed     = vec3(1.0, 0.0, 0.0);
        mediump vec3 colorLime    = vec3(0.0, 1.0, 0.0);
        mediump vec3 colorBlue    = vec3(0.0, 0.0, 1.0);
        mediump vec3 colorYellow  = vec3(1.0, 1.0, 0.0);
        mediump vec3 colorCyan    = vec3(0.0, 1.0, 1.0);
        mediump vec3 colorMagenta = vec3(1.0, 0.0, 1.0);

        mediump vec3 endColor;
        highp float blackDistance   = distance(color, colorBlack);
        highp float whiteDistance   = distance(color, colorWhite);
        highp float redDistance     = distance(color, colorRed);
        highp float limeDistance    = distance(color, colorLime);
        highp float blueDistance    = distance(color, colorBlue);
        highp float yellowDistance  = distance(color, colorYellow);
        highp float magentaDistance = distance(color, colorMagenta);
        highp float cyanDistance    = distance(color, colorCyan);

        mediump vec3 finalColor;

        highp float colorDistance = min(magentaDistance, cyanDistance);
        colorDistance = min(colorDistance, yellowDistance);
        colorDistance = min(colorDistance, blueDistance);
        colorDistance = min(colorDistance, limeDistance);
        colorDistance = min(colorDistance, redDistance);
        colorDistance = min(colorDistance, whiteDistance);
        colorDistance = min(colorDistance, blackDistance);

        if (colorDistance == blackDistance)
        {
            finalColor = colorBlack;
        }
        else if (colorDistance == whiteDistance)
        {
            finalColor = colorWhite;
        }
        else if (colorDistance == cyanDistance)
        {
            finalColor = colorCyan;
        }
        else if (colorDistance == redDistance)
        {
            finalColor = colorRed;
        }
        else if (colorDistance == limeDistance)
        {
            finalColor = colorLime;
        }
        else if (colorDistance == blueDistance)
        {
            finalColor = colorBlue;
        }
        else if (colorDistance == yellowDistance)
        {
            finalColor = colorYellow;
        }
        else
        {
            finalColor = colorMagenta;
        }

        gl_FragColor = vec4(finalColor * texture2D(source, qt_TexCoord0).a, texture2D(source, qt_TexCoord0).a) * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}

