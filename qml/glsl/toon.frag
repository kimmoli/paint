// Toonify
// Quantize;1.0;15.0;Tolerance;0.0;0.6

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float param1;
uniform lowp float param2;
uniform highp float width;
uniform highp float height;

void main()
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        highp float quantize = param1;
        highp float magTol = param2;
        highp float resS = width;
        highp float resT = height;

        highp vec4 color = vec4(1.0, 0.0, 0.0, 1.1);
        highp vec2 uv = qt_TexCoord0.xy;

        highp vec2 st = qt_TexCoord0.st;
        highp vec3 rgb = texture2D(source, st).rgb / texture2D(source, st).a;
        lowp vec2 stp0 = vec2(1.0/resS,  0.0);
        lowp vec2 st0p = vec2(0.0     ,  1.0/resT);
        lowp vec2 stpp = vec2(1.0/resS,  1.0/resT);
        lowp vec2 stpm = vec2(1.0/resS, -1.0/resT);
        highp float i00 =   dot( texture2D(source, st).rgb, vec3(0.2125,0.7154,0.0721));
        highp float im1m1 = dot( texture2D(source, st-stpp).rgb, vec3(0.2125,0.7154,0.0721));
        highp float ip1p1 = dot( texture2D(source, st+stpp).rgb, vec3(0.2125,0.7154,0.0721));
        highp float im1p1 = dot( texture2D(source, st-stpm).rgb, vec3(0.2125,0.7154,0.0721));
        highp float ip1m1 = dot( texture2D(source, st+stpm).rgb, vec3(0.2125,0.7154,0.0721));
        highp float im10 =  dot( texture2D(source, st-stp0).rgb, vec3(0.2125,0.7154,0.0721));
        highp float ip10 =  dot( texture2D(source, st+stp0).rgb, vec3(0.2125,0.7154,0.0721));
        highp float i0m1 =  dot( texture2D(source, st-st0p).rgb, vec3(0.2125,0.7154,0.0721));
        highp float i0p1 =  dot( texture2D(source, st+st0p).rgb, vec3(0.2125,0.7154,0.0721));
        highp float h = -1.*im1p1 - 2.*i0p1 - 1.*ip1p1  +  1.*im1m1 + 2.*i0m1 + 1.*ip1m1;
        highp float v = -1.*im1m1 - 2.*im10 - 1.*im1p1  +  1.*ip1m1 + 2.*ip10 + 1.*ip1p1;
        highp float mag = sqrt(h*h + v*v);

        if (mag > magTol)
        {
            color = vec4(0.0, 0.0, 0.0, 1.0);
        }
        else
        {
            rgb.rgb *= quantize;
            rgb.rgb += vec3(0.5, 0.5, 0.5);
            highp ivec3 irgb = ivec3(rgb.rgb);
            rgb.rgb = vec3(irgb) / quantize;
            color = vec4(rgb*texture2D(source, st).a, texture2D(source, st).a);
        }
        gl_FragColor = color * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
  }
