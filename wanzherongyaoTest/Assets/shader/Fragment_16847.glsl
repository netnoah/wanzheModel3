




precision highp float;
uniform highp mat4 _Object2World;
uniform mediump float _Dissolve;
uniform mediump float _DissolvePow;
uniform mediump float _DissolveCover;
uniform mediump float _DissolveMultiplier;
uniform mediump float _SpecPower;
uniform mediump float _SpecMultiplier;
uniform mediump vec3 _DissolveColor;
uniform mediump vec3 _SpecColor;
uniform highp float _DissolveOffset;
uniform sampler2D _MainTex;
uniform sampler2D _MaskTex;
uniform sampler2D _LightTex;
uniform sampler2D _DissolveTex;
uniform sampler2D _RampMap;
varying mediump vec4 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec3 Glow_2;
  mediump vec4 DissolveTex_3;
  mediump float noda_4;
  mediump float noda_B_5;
  mediump float node_A_6;
  mediump vec3 color_7;
  mediump float gloss_8;
  mediump vec3 albedo_9;
  mediump vec2 tmpvar_10;
  tmpvar_10 = ((normalize(xlv_TEXCOORD1).xy * 0.5) + 0.5);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_11.xyz + 0.15) * (texture2D (_LightTex, tmpvar_10) * 1.2).xyz);
  albedo_9 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = (albedo_9 + tmpvar_11.xyz);
  albedo_9 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_MaskTex, xlv_TEXCOORD0.xy).x;
  gloss_8 = tmpvar_14;
  mediump vec3 color_15;
  mediump vec3 ramp_16;
  highp float nh_17;
  lowp float diff_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((xlv_TEXCOORD3.z * 0.5) + 0.5);
  diff_18 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, normalize((xlv_TEXCOORD3 + xlv_TEXCOORD2)).z);
  nh_17 = tmpvar_20;
  lowp vec2 tmpvar_21;
  tmpvar_21.y = 0.5;
  tmpvar_21.x = diff_18;
  lowp vec3 tmpvar_22;
  tmpvar_22 = texture2D (_RampMap, tmpvar_21).xyz;
  ramp_16 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((_SpecColor * (
    ((nh_17 * tmpvar_13) * gloss_8)
  .x + 
    (((pow (nh_17, _SpecPower) * gloss_8) * _SpecMultiplier) * 2.0)
  )) + ((ramp_16 + vec3(0.5, 0.5, 0.5)) * tmpvar_13));
  color_15 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (_Object2World * vec4(0.0, 0.0, 0.0, 1.0));
  highp float tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD4.y - tmpvar_24.y);
  node_A_6 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (1.0 - (xlv_TEXCOORD4.y - tmpvar_24.y));
  noda_B_5 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = mix (node_A_6, noda_B_5, _DissolveOffset);
  noda_4 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_DissolveTex, xlv_TEXCOORD0.zw);
  DissolveTex_3 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = (clamp ((
    (_Dissolve + ((dot (DissolveTex_3, vec4(0.3, 0.59, 0.11, 0.0)) * noda_4) + noda_4))
   - 1.0), 0.0, 1.0) * 4.0);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (((1.0 - tmpvar_29) - _DissolveCover), 0.0, 1.0);
  mediump vec3 tmpvar_31;
  tmpvar_31 = ((DissolveTex_3.xyz * _DissolveColor) * _DissolveMultiplier);
  Glow_2 = tmpvar_31;
  mediump float x_32;
  x_32 = (tmpvar_29 - _DissolvePow);
  if ((x_32 < 0.0)) {
    discard;
  };
  highp vec3 tmpvar_33;
  tmpvar_33 = mix (color_15, (color_15 + Glow_2), vec3(tmpvar_30));
  color_7 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.xyz = color_7;
  tmpvar_34.w = tmpvar_11.w;
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



 