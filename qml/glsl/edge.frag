// Edge detection
// Threshold;0.1;0.9

// Origin: http://coding-experiments.blogspot.fi/2010/06/edge-detection.html

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform highp float width;
uniform highp float height;
uniform lowp float param1;

float threshold(in float thr1, in float thr2 , in float val)
{
    if (val < thr1) {return 0.0;}
    if (val > thr2) {return 1.0;}
    return val;
}

// averaged pixel intensity from 3 color channels
float avg_intensity(in vec4 pix)
{
    return (pix.r + pix.g + pix.b)/3.;
}

vec4 get_pixel(in vec2 coords, in float dx, in float dy)
{
    return texture2D(source,coords + vec2(dx, dy));
}

// returns pixel color
float IsEdge(in vec2 coords)
{
    float dxtex = 1.0 / width;
    float dytex = 1.0 / height;
    float pix[9];
    int k = -1;
    float delta;

    // read neighboring pixel intensities
    for (int i=-1; i<2; i++)
    {
        for(int j=-1; j<2; j++)
        {
            k++;
            pix[k] = avg_intensity(get_pixel(coords,float(i)*dxtex, float(j)*dytex));
        }
    }

    // average color differences around neighboring pixels
    delta = (abs(pix[1]-pix[7])+
             abs(pix[5]-pix[3]) +
             abs(pix[0]-pix[8])+
             abs(pix[2]-pix[6])
             )/4.;

    return threshold(param1-0.075,param1+0.075,clamp(1.8*delta,0.0,1.0));
}

void main()
{
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        vec4 color = vec4(0.0,0.0,0.0,1.0);
        color.rgb = vec3(IsEdge(qt_TexCoord0.xy));

        gl_FragColor = color * qt_Opacity;
    }
    else
    {
        gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
    }
}
