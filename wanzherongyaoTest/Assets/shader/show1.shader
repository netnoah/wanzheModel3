Shader "T/show1" {
	Properties 
	{
		 _MainTex ("Base (RGB)", 2D) = "white" {}
		 _MaskTex ("Mask (R,G,B)", 2D) = "white" {}
		 _SpecColor ("Spec Color", Color) = (0.963,0.954,0.383,0)
		 _SpecPower ("Spec Power", Range(1,128)) = 19.14
		 _SpecMultiplier ("Spec Multiplier", Float) = 1
		 _RampMap ("Ramp Map", 2D) = "white" {}
		 _ShadowColor ("Shadow Color", Color) = (0,0,0,0)
		 _LightTex ("轮廓光 (RGB)", 2D) = "white" {}
		 _NormalTex ("Normal", 2D) = "bump" {}
		 _NoiseTex ("Noise(RGB)", 2D) = "white" {}
		 _Scroll2X ("Noise speed X", Float) = -3
		 _Scroll2Y ("Noise speed Y", Float) = -3
		 _NoiseColor ("Noise Color", Color) = (0,0,0,1)
		 _MMultiplier ("Layer Multiplier", Float) = 6
		 _ReflectTex ("Reflect(RGB)", 2D) = "white" {}
		 _ReflectColor ("Reflect Color", Color) = (1,1,1,1)
		 _ReflectPower ("Reflect Power", Range(0.1,5)) = 1
		 _ReflectionMultiplier ("Reflection Multiplier", Float) = 2
		 _Offset ("Height", Float) = 0.8
		 _HeightColor ("Height Color", Color) = (0.4804,0.3512,0.5368,1)
		 _HeightLightCompensation ("Height Light Compensation", Float) = 1
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"
		sampler2D _MainTex;	
		sampler2D _MaskTex;
		sampler2D _RampMap;
		sampler2D _LightTex;
		sampler2D _NoiseTex;
		sampler2D _ReflectTex;
		
		uniform float4 _MainTex_ST;
		uniform float4 _NoiseTex_ST;
		uniform float4 _SpecColor;
		uniform float _SpecPower;
		uniform float _SpecMultiplier;
		uniform float4 _ShadowColor;
		uniform float _Scroll2X;
		uniform float _Scroll2Y;
		uniform float4 _NoiseColor;
		uniform float _MMultiplier;
		uniform float4 _ReflectColor;
		uniform float _ReflectPower;
		uniform float _ReflectionMultiplier;
		uniform float _Offset;
		uniform float4 _HeightColor;
		uniform float _HeightLightCompensation;
		
		uniform float4 _SGameShadowParams;
				
		struct v2f 
		{
			float4 pos : SV_POSITION;
			half4 uv0 : TEXCOORD0;	
			half3 uv1 : TEXCOORD1;
			half3 uv2 : TEXCOORD2;
			half3 uv3 : TEXCOORD3;
			half4 uv4 : TEXCOORD4;		
			half3 uv5 : TEXCOORD5;			
		};

		v2f vert(appdata_full v)
		{
			v2f o;
			
			//_SGameShadowParams = float4(-0.486, -0.271, 0.831, 0.5);
			//_SGameShadowParams = float4(-0.376, -0.2997, 0.8767, 0.5);
			
			float4 n_tangent;
			n_tangent.xyz = normalize(v.tangent.xyz);
			n_tangent.w = v.tangent.w;
			
			float3 n_normal = normalize(v.normal);
			
			half4 result_uv;
			result_uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
			result_uv.zw = TRANSFORM_TEX(v.texcoord,_NoiseTex) + frac(half2(_Scroll2X, _Scroll2Y) * _Time.x);
 
			half3 v_normal = mul(UNITY_MATRIX_MV, float4(n_normal, 0)).xyz;
			float4 world_pos = mul(_Object2World, v.vertex);
			  
			float3 binormal = cross( v.normal, v.tangent.xyz ) * v.tangent.w;
			float3x3 tangentspace_rotation = float3x3( v.tangent.xyz, binormal, v.normal );
  
			float4 viewdir;
			viewdir.w = 0.0;
			viewdir.xyz = (_WorldSpaceCameraPos - world_pos.xyz);
			float3 t_viewdir = normalize(mul(tangentspace_rotation, mul(_World2Object, viewdir).xyz));

			float4 lightdir;
			lightdir.w = 0.0;
			lightdir.xyz = -(_SGameShadowParams.xyz);
			float3 t_lightdir = normalize(mul(tangentspace_rotation, mul(_World2Object, lightdir).xyz));

			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv0 = result_uv;
			o.uv1 = v_normal;
			o.uv2 = t_viewdir;
			o.uv3 = t_lightdir;
			o.uv4 = world_pos;
			o.uv5 = mul(_Object2World, float4(n_normal, 0)).xyz;
						
			return o; 
		}
		
		fixed4 frag( v2f i ) : COLOR
		{
		      fixed4 tmpvar_1;
			  half gloss_2;
			  half3 noise_3;
			  half3 albedo_4;
			  half2 tmpvar_5;
			  half3 cse_6;
			  cse_6 = normalize(i.uv1);
			  tmpvar_5 = ((cse_6.xy * 0.5) + 0.5);
			  fixed4 tmpvar_7;
			  tmpvar_7 = tex2D (_MainTex, i.uv0.xy);
			  fixed4 tmpvar_8;
			  tmpvar_8 = tex2D (_MaskTex, i.uv0.xy);
			  fixed3 tmpvar_9;
			  tmpvar_9 = ((tmpvar_7.xyz + 0.15) * (tex2D (_LightTex, tmpvar_5) * 1.2).xyz);
			  albedo_4 = tmpvar_9;
			  fixed3 tmpvar_10;
			  tmpvar_10 = tex2D (_NoiseTex, i.uv0.zw).xyz;
			  noise_3 = tmpvar_10;
			  half3 tmpvar_11;
			  tmpvar_11 = ((noise_3 * (tmpvar_7.xyz * _NoiseColor)) * (tmpvar_8.y * _MMultiplier));
			  noise_3 = tmpvar_11;
			  half3 tmpvar_12;
			  tmpvar_12 = ((albedo_4 + tmpvar_7.xyz) + tmpvar_11);
			  half2 tmpvar_13;
			  tmpvar_13 = ((cse_6.xy * 0.5) + 0.5);
			  fixed4 tmpvar_14;
			  tmpvar_14 = tex2D (_ReflectTex, tmpvar_13);
			  half3 tmpvar_15;
			  tmpvar_15 = lerp (tmpvar_12, ((tmpvar_12 * 
				pow ((tmpvar_14.xyz * _ReflectColor), _ReflectPower)) * _ReflectionMultiplier), tmpvar_8.zzz);
			  albedo_4 = tmpvar_15;
			  fixed tmpvar_16;
			  tmpvar_16 = tmpvar_8.x;
			  gloss_2 = tmpvar_16;
			  half3 color_17;
			  half3 ramp_18;
			  float nh_19;
			  fixed diff_20;
			  half tmpvar_21;
			  tmpvar_21 = ((i.uv3.z * 0.5) + 0.5);
			  diff_20 = tmpvar_21;
			  half tmpvar_22;
			  tmpvar_22 = max (0.0, normalize((i.uv3 + i.uv2)).z);
			  nh_19 = tmpvar_22;
			  fixed2 tmpvar_23;
			  tmpvar_23.y = 0.5;
			  tmpvar_23.x = diff_20;
			  fixed tmpvar_24;
			  tmpvar_24 = tex2D (_RampMap, tmpvar_23).xyz;
			  ramp_18 = tmpvar_24;
			  float3 tmpvar_25;
			  tmpvar_25 = ((_SpecColor * (
				((pow (nh_19, _SpecPower) * gloss_2) * _SpecMultiplier)
			   * 2.0)) + ((ramp_18 + fixed3(0.5, 0.5, 0.5)) * tmpvar_15));
			  color_17 = tmpvar_25;
			  half3 tmpvar_26;
			  float3 tmpvar_27;
			  tmpvar_27 = clamp (((color_17 * 
				lerp (_HeightColor.xyz, fixed3(1.0, 1.0, 1.0), 
				clamp ((fixed((i.uv4.y - (mul(_Object2World, fixed4(0.0, 0.0, 0.0, 1.0)).y - _Offset))) + fixed((normalize(i.uv5).y * 0.5))), 0.0, 1.0))
				) * _HeightLightCompensation), 0.0, 1.0);
			  tmpvar_26 = tmpvar_27;
			  half4 tmpvar_28;
			  tmpvar_28.xyz = tmpvar_26;
			  tmpvar_28.w = tmpvar_7.w;
			  tmpvar_1 = tmpvar_28;

			  //return fixed4(clamp ((fixed((i.uv4.y - _Offset)) + fixed((normalize(i.uv5).y * 0.5))), 0.0, 1.0), 0, 0, 1);
			  //tmpvar_1.xyz = lerp (_HeightColor.xyz, fixed3(1.0, 1.0, 1.0), clamp ((fixed((i.uv4.y - (mul(_Object2World, fixed4(0.0, 0.0, 0.0, 1.0)).y - _Offset))) + fixed((normalize(i.uv5).y * 0.5))), 0.0, 1.0));

			  return tmpvar_1;
		}
	
	ENDCG
	
	SubShader 
	{
		Tags {"IgnoreProjector" = "true"}

		Pass 
		{
			CGPROGRAM		
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest 		
			ENDCG	 
		}				
	} 
	FallBack Off
}
