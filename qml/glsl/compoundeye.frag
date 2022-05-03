// Compound Eye
// amt;0.1;2.0;squares;2.0;20.0;offset;0.05;1.0

precision mediump float;

uniform sampler2D source;
uniform sampler2D mask;
varying highp vec2 qt_TexCoord0;
uniform lowp float qt_Opacity;
uniform lowp float width;
uniform lowp float height;
uniform highp float param1;
uniform highp float param2;
uniform highp float param3;

void main() {

  //float aspect = resolution.x / resolution.y;
  float aspect = width / height;
  float offset = param1 * 0.5;

   if (texture2D(mask, qt_TexCoord0.st).a > 0.5)
   {

      vec2 uv = qt_TexCoord0.xy;

      /* copy of the texture coords */
      vec2 tc = uv;

      /* move into a range of -0.5 - 0.5 */
      uv -= 0.5;

      /* correct for window aspect to make param2 */
      uv.x *= aspect;

      /* tile will be used to offset the texture coordinates
         taking the fract will give us repeating patterns */
      vec2 tile = fract(uv * param2 + 0.5) * param1;

      /* sample the texture using our computed tile
         offset will remove some texcoord edge artifacting */
      vec4 tex = texture2D(source, tc + tile - offset);
      gl_FragColor = tex;
   }
   else
   {
       gl_FragColor = texture2D(source, qt_TexCoord0.st) * qt_Opacity;
   }
}
