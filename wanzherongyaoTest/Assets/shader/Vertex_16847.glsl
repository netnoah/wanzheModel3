




attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesTANGENT;
uniform highp vec4 _Time;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform mediump float _ScrollX;
uniform mediump float _ScrollY;
uniform highp vec4 _SGameShadowParams;
uniform highp mat4 _SGameShadowMatrix;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _DissolveTex_ST;
varying mediump vec4 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec4 xlv_TEXCOORD6;
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
  mediump vec2 tmpvar_8;
  tmpvar_8.x = _ScrollX;
  tmpvar_8.y = _ScrollY;
  highp vec2 tmpvar_9;
  tmpvar_9 = (((_glesMultiTexCoord0.xy * _DissolveTex_ST.xy) + _DissolveTex_ST.zw) + fract((tmpvar_8 * _Time.x)));
  tmpvar_3.zw = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_2;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_1.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_2);
  highp vec3 tmpvar_16;
  tmpvar_16 = (((tmpvar_15.yzx * tmpvar_14.zxy) - (tmpvar_15.zxy * tmpvar_14.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_14.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_15.x;
  tmpvar_17[1].x = tmpvar_14.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_15.y;
  tmpvar_17[2].x = tmpvar_14.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_15.z;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (_WorldSpaceCameraPos - tmpvar_12.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_17 * (_World2Object * tmpvar_18).xyz));
  tmpvar_5 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = -(_SGameShadowParams.xyz);
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_17 * (_World2Object * tmpvar_20).xyz));
  tmpvar_6 = tmpvar_21;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_12;
  xlv_TEXCOORD5 = (_Object2World * tmpvar_13).xyz;
  xlv_TEXCOORD6 = (_SGameShadowMatrix * tmpvar_12);
}



