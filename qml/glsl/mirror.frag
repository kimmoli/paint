// Mirrors


precision highp float;

uniform sampler2D source;
uniform vec2 resolution;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;

void main() {
    if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
    {
        vec2 uv = qt_TexCoord0.xy;
        // the texture is loaded upside down and backwards by default so lets flip it
        uv = 1.0 - uv;

        // this line will make our uvs mirrored
        // it will convert it into a number that goes 0 to 1 to 0
        // abs() will turn our negative numbers positive
        vec2 mirrorUvs = abs(uv * 2.0  - 1.0);
  
        vec4 tex = texture2D(source, mirrorUvs);

          // output to screen
          gl_FragColor = tex;

        } else {
                gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
        }
}
