




precision highp float;
uniform mediump float _MMultiplier;
uniform mediump float _SpecPower;
uniform mediump float _SpecMultiplier;
uniform mediump float _ReflectPower;
uniform mediump float _ReflectionMultiplier;
uniform mediump vec3 _NoiseColor;
uniform mediump vec3 _SpecColor;
uniform mediump vec3 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _MaskTex;
uniform sampler2D _LightTex;
uniform sampler2D _NoiseTex;
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
  mediump vec3 noise_3;
  mediump vec3 albedo_4;
  mediump vec2 tmpvar_5;
  mediump vec3 cse_6;
  cse_6 = normalize(xlv_TEXCOORD1);
  tmpvar_5 = ((cse_6.xy * 0.5) + 0.5);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MaskTex, xlv_TEXCOORD0.xy);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((tmpvar_7.xyz + 0.15) * (texture2D (_LightTex, tmpvar_5) * 1.2).xyz);
  albedo_4 = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = texture2D (_NoiseTex, xlv_TEXCOORD0.zw).xyz;
  noise_3 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = ((noise_3 * (tmpvar_7.xyz * _NoiseColor)) * (tmpvar_8.y * _MMultiplier));
  noise_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = ((albedo_4 + tmpvar_7.xyz) + tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13 = ((cse_6.xy * 0.5) + 0.5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ReflectTex, tmpvar_13);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (tmpvar_12, ((tmpvar_12 * 
    pow ((tmpvar_14.xyz * _ReflectColor), vec3(_ReflectPower))
  ) * _ReflectionMultiplier), tmpvar_8.zzz);
  albedo_4 = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = tmpvar_8.x;
  gloss_2 = tmpvar_16;
  mediump vec3 color_17;
  mediump vec3 ramp_18;
  highp float nh_19;
  lowp float diff_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((xlv_TEXCOORD3.z * 0.5) + 0.5);
  diff_20 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, normalize((xlv_TEXCOORD3 + xlv_TEXCOORD2)).z);
  nh_19 = tmpvar_22;
  lowp vec2 tmpvar_23;
  tmpvar_23.y = 0.5;
  tmpvar_23.x = diff_20;
  lowp vec3 tmpvar_24;
  tmpvar_24 = texture2D (_RampMap, tmpvar_23).xyz;
  ramp_18 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = ((_SpecColor * (
    ((pow (nh_19, _SpecPower) * gloss_2) * _SpecMultiplier)
   * 2.0)) + ((ramp_18 + vec3(0.5, 0.5, 0.5)) * tmpvar_15));
  color_17 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.xyz = color_17;
  tmpvar_26.w = tmpvar_7.w;
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}



