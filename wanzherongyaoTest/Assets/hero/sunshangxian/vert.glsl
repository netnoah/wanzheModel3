




attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _SGameShadowParams;
uniform highp vec4 _MainTex_ST;
varying mediump vec4 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.xy = tmpvar_7;
  tmpvar_3.zw = tmpvar_3.xy;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2;
  highp vec3 tmpvar_9;
  tmpvar_9 = (glstate_matrix_modelview0 * tmpvar_8).xyz;
  tmpvar_4 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize(tmpvar_1.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_2);
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_11.yzx * tmpvar_10.zxy) - (tmpvar_11.zxy * tmpvar_10.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_10.x;
  tmpvar_13[0].y = tmpvar_12.x;
  tmpvar_13[0].z = tmpvar_11.x;
  tmpvar_13[1].x = tmpvar_10.y;
  tmpvar_13[1].y = tmpvar_12.y;
  tmpvar_13[1].z = tmpvar_11.y;
  tmpvar_13[2].x = tmpvar_10.z;
  tmpvar_13[2].y = tmpvar_12.z;
  tmpvar_13[2].z = tmpvar_11.z;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((tmpvar_13 * (_World2Object * tmpvar_14).xyz));
  tmpvar_5 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 0.0;
  tmpvar_16.xyz = -(_SGameShadowParams.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_13 * (_World2Object * tmpvar_16).xyz));
  tmpvar_6 = tmpvar_17;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
}



