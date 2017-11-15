




precision highp float;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform sampler2D _CupTex;
uniform mediump float _Level;
uniform mediump float _ColorLevel;
varying mediump vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec4 cuptex_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  tmpvar_3.w = texture2D (_AlphaTex, xlv_TEXCOORD0).x;
  color_2 = tmpvar_3;
  mediump vec2 tmpvar_4;
  tmpvar_4 = ((normalize(xlv_TEXCOORD2).xy * 0.5) + 0.5);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_CupTex, tmpvar_4);
  cuptex_1 = tmpvar_5;
  color_2.xyz = (((color_2 * _ColorLevel) * xlv_TEXCOORD1) + (cuptex_1 * _Level)).xyz;
  color_2.xyz = color_2.xyz;
  color_2.w = (((color_2.w * vec4(
    dot (cuptex_1, vec4(0.5, 0.5, 0.5, 0.0))
  )) * xlv_TEXCOORD1.w) * 2.0).x;
  gl_FragData[0] = color_2;
}



