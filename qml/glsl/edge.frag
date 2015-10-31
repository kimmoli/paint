// Edge detection
// Threshold;0.0;1.0;Margin;0.0;0.5;Mix;0.0;1.0

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;
uniform lowp float param1;
uniform lowp float param2;
uniform lowp float param3;

void main(void)
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp vec4 color = texture2D(source, qt_TexCoord0.st);

        float ResS = width;
        float ResT = height;
        vec3 irgb = color.rgb/color.a;
        vec2 stp0 = vec2(1./ResS, 0. );
        vec2 st0p = vec2(0. , 1./ResT);
        vec2 stpp = vec2(1./ResS, 1./ResT);
        vec2 stpm = vec2(1./ResS, -1./ResT);
        const vec3 W = vec3( 0.2125, 0.7154, 0.0721 );
        float i00 = dot( texture2D(source, qt_TexCoord0.st ).rgb, W );
        float im1m1 = dot( texture2D(source, qt_TexCoord0.st-stpp ).rgb, W );
        float ip1p1 = dot( texture2D(source, qt_TexCoord0.st+stpp ).rgb, W );
        float im1p1 = dot( texture2D(source, qt_TexCoord0.st-stpm ).rgb, W );
        float ip1m1 = dot( texture2D(source, qt_TexCoord0.st+stpm ).rgb, W );
        float im10 = dot( texture2D(source, qt_TexCoord0.st-stp0 ).rgb, W );
        float ip10 = dot( texture2D(source, qt_TexCoord0.st+stp0 ).rgb, W );
        float i0m1 = dot( texture2D(source, qt_TexCoord0.st-st0p ).rgb, W );
        float i0p1 = dot( texture2D(source, qt_TexCoord0.st+st0p ).rgb, W );
        float h= -1.*im1p1-2.*i0p1-1.*ip1p1+1.*im1m1+2.*i0m1+1.*ip1m1;
        float v= -1.*im1m1-2.*im10-1.*im1p1+1.*ip1m1+2.*ip10+1.*ip1p1;
        float mag = length( vec2( h, v ) );

        if (mag > param1+param2)
            mag = 1.0;
        else if (mag < param1-param2)
            mag = 0.0;

        vec3 target = vec3( mag, mag, mag );

        gl_FragColor = vec4( mix( irgb, target, 1.0-param3 ), 1.0 ) * color.a * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
