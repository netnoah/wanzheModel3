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
			  half3 normalize_n = normalize(i.uv1);
			  half2 fixed_n = ((normalize_n.xy * 0.5) + 0.5);
			  fixed4 main_color = tex2D (_MainTex, i.uv0.xy);
			  fixed4 mask_color = tex2D (_MaskTex, i.uv0.xy);
			  half3 resultColor_1 = ((main_color.xyz + 0.15) * (tex2D (_LightTex, fixed_n) * 1.2).xyz);
			  half3 noise_color = tex2D (_NoiseTex, i.uv0.zw).xyz;
			  half3 noise_color2 = ((noise_color * (main_color.xyz * _NoiseColor)) * (mask_color.y * _MMultiplier));
			  half3 resultColor_2 = ((resultColor_1 + main_color.xyz) + noise_color2);
			  fixed4 reflect_color = tex2D (_ReflectTex, fixed_n);
			  half3 resultColor_3 = lerp (resultColor_2, 
										((resultColor_2 * pow ((reflect_color.xyz * _ReflectColor), _ReflectPower)) * _ReflectionMultiplier),
										mask_color.zzz);
			  fixed2 ramp_uv;
			  ramp_uv.x = ((i.uv3.z * 0.5) + 0.5);
			  ramp_uv.y = 0.5;
			  half3 ramp_color = tex2D (_RampMap, ramp_uv).xyz;
			  float halfway_dir = max (0.0, normalize((i.uv3 + i.uv2)).z);  
			  half gloss = mask_color.x;
			  float3 resultColor_4 = ((_SpecColor * (((pow (halfway_dir, _SpecPower) * gloss) * _SpecMultiplier)* 2.0)) + 
										((ramp_color + fixed3(0.5, 0.5, 0.5)) * resultColor_3));

			  fixed4 finalColor;
			  finalColor.xyz = clamp (((resultColor_4 * 
						lerp (_HeightColor.xyz, fixed3(1.0, 1.0, 1.0), 
						clamp ((fixed((i.uv4.y - (mul(_Object2World, fixed4(0.0, 0.0, 0.0, 1.0)).y - _Offset))) + fixed((normalize(i.uv5).y * 0.5))), 0.0, 1.0)
						)) * _HeightLightCompensation), 0.0, 1.0);
			  finalColor.w = main_color.w;

			  //return fixed4(clamp ((fixed((i.uv4.y - _Offset)) + fixed((normalize(i.uv5).y * 0.5))), 0.0, 1.0), 0, 0, 1);
			  return finalColor;
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
