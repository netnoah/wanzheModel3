




precision highp float;
uniform highp mat4 _Object2World;
uniform mediump float _MMultiplier;
uniform mediump float _SpecPower;
uniform mediump float _SpecMultiplier;
uniform mediump vec3 _NoiseColor;
uniform mediump vec3 _SpecColor;
uniform highp float _Offset;
uniform mediump vec4 _HeightColor;
uniform highp float _HeightLightCompensation;
uniform sampler2D _MainTex;
uniform sampler2D _MaskTex;
uniform sampler2D _LightTex;
uniform sampler2D _NoiseTex;
uniform sampler2D _RampMap;
varying mediump vec4 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float gloss_2;
  mediump vec3 noise_3;
  mediump vec3 albedo_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = ((normalize(xlv_TEXCOORD1).xy * 0.5) + 0.5);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MaskTex, xlv_TEXCOORD0.xy);
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((tmpvar_6.xyz + 0.15) * (texture2D (_LightTex, tmpvar_5) * 1.2).xyz);
  albedo_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = texture2D (_NoiseTex, xlv_TEXCOORD0.zw).xyz;
  noise_3 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((noise_3 * (tmpvar_6.xyz * _NoiseColor)) * (tmpvar_7.y * _MMultiplier));
  noise_3 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = ((albedo_4 + tmpvar_6.xyz) + tmpvar_10);
  albedo_4 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_7.x;
  gloss_2 = tmpvar_12;
  mediump vec3 color_13;
  mediump vec3 ramp_14;
  highp float nh_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((xlv_TEXCOORD3.z * 0.5) + 0.5);
  diff_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, normalize((xlv_TEXCOORD3 + xlv_TEXCOORD2)).z);
  nh_15 = tmpvar_18;
  lowp vec2 tmpvar_19;
  tmpvar_19.y = 0.5;
  tmpvar_19.x = diff_16;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_RampMap, tmpvar_19).xyz;
  ramp_14 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((_SpecColor * (
    ((pow (nh_15, _SpecPower) * gloss_2) * _SpecMultiplier)
   * 2.0)) + ((ramp_14 + vec3(0.5, 0.5, 0.5)) * tmpvar_11));
  color_13 = tmpvar_21;
  mediump vec3 tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = clamp (((color_13 * 
    mix (_HeightColor.xyz, vec3(1.0, 1.0, 1.0), clamp ((vec3((xlv_TEXCOORD4.y - 
      ((_Object2World * vec4(0.0, 0.0, 0.0, 1.0)).y - _Offset)
    )) + vec3((
      normalize(xlv_TEXCOORD5)
    .y * 0.5))), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)))
  ) * _HeightLightCompensation), 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24.xyz = tmpvar_22;
  tmpvar_24.w = tmpvar_6.w;
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}



