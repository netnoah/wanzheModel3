




attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _Time;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform mediump vec4 _MainTex_ST;
uniform highp float _ScrollX;
uniform highp float _ScrollY;
uniform mediump vec4 _Color;
varying mediump vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec2 tmpvar_1;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = _ScrollX;
  tmpvar_4.y = _ScrollY;
  highp vec2 tmpvar_5;
  tmpvar_5 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + fract((tmpvar_4 * _Time.x)));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_7;
  tmpvar_7 = (glstate_matrix_modelview0 * tmpvar_6).xyz;
  tmpvar_3 = tmpvar_7;
  mediump vec4 tmpvar_8;
  tmpvar_8 = (_glesColor * _Color);
  tmpvar_2 = tmpvar_8;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



