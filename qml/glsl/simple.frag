// Swap color channels RGB --> BRG

uniform sampler2D source;
varying highp vec2 qt_TexCoord0;

void main(void)
{
    gl_FragColor = texture2D(source, qt_TexCoord0).brga;
}
