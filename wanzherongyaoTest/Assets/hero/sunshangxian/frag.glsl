




precision highp float;
uniform mediump float _SpecPower;
uniform mediump float _SpecMultiplier;
uniform mediump float _ReflectPower;
uniform mediump float _ReflectionMultiplier;
uniform mediump vec3 _SpecColor;
uniform mediump vec3 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _MaskTex;
uniform sampler2D _LightTex;
uniform sampler2D _ReflectTex;
uniform sampler2D _RampMap;
varying mediump vec4 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float gloss_2;
  mediump vec3 albedo_3;
  mediump vec2 tmpvar_4;
  mediump vec3 cse_5;
  cse_5 = normalize(xlv_TEXCOORD1);
  tmpvar_4 = ((cse_5.xy * 0.5) + 0.5);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MaskTex, xlv_TEXCOORD0.xy);
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((tmpvar_6.xyz + 0.15) * (texture2D (_LightTex, tmpvar_4) * 1.2).xyz);
  albedo_3 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (albedo_3 + tmpvar_6.xyz);
  mediump vec2 tmpvar_10;
  tmpvar_10 = ((cse_5.xy * 0.5) + 0.5);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ReflectTex, tmpvar_10);
  mediump vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_9, ((tmpvar_9 * 
    pow ((tmpvar_11.xyz * _ReflectColor), vec3(_ReflectPower))
  ) * _ReflectionMultiplier), tmpvar_7.zzz);
  albedo_3 = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = tmpvar_7.x;
  gloss_2 = tmpvar_13;
  mediump vec3 color_14;
  mediump vec3 ramp_15;
  highp float nh_16;
  lowp float diff_17;
  mediump float tmpvar_18;
  tmpvar_18 = ((xlv_TEXCOORD3.z * 0.5) + 0.5);
  diff_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, normalize((xlv_TEXCOORD3 + xlv_TEXCOORD2)).z);
  nh_16 = tmpvar_19;
  lowp vec2 tmpvar_20;
  tmpvar_20.y = 0.5;
  tmpvar_20.x = diff_17;
  lowp vec3 tmpvar_21;
  tmpvar_21 = texture2D (_RampMap, tmpvar_20).xyz;
  ramp_15 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = ((_SpecColor * (
    ((pow (nh_16, _SpecPower) * gloss_2) * _SpecMultiplier)
   * 2.0)) + ((ramp_15 + vec3(0.5, 0.5, 0.5)) * tmpvar_12));
  color_14 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.xyz = color_14;
  tmpvar_23.w = tmpvar_6.w;
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}



