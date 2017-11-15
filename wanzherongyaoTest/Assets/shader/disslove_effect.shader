
Shader "T/Disslove" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_DissolveTex ("_DissolveTex)", 2D) = "white" {}
		_ScrollX ("_ScrollX", float ) = 1.0
		_ScrollY ("_ScrollY", float ) = 1.0
		_Disslove ("_Disslove", float) = 1.0
		_DissolveCover ("_DissolveCover", float) = 1.0
		_DissolveMultiplier ("_DissolveMultiplier", float) = 1.0
		_DissolvePow ("_DissolvePow", float) = 1.0
		_DissolveOffset("_DissolveOffset", float) = 1.0
		_DissolveColor("_DissolveColor", Color) = (1, 1, 1, 1)
	}

	SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque"}
	Fog {Mode Off}
	Blend SrcAlpha OneMinusSrcAlpha 
	ColorMask RGB
	
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord1 : TEXCOORD1;
				half3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord1 : TEXCOORD1;
				float4 worldPos : TEXCOORD2;
			};

			sampler2D _MainTex;
			sampler2D _DissolveTex;
			fixed4 _Color;
			fixed _ScrollX;
			fixed _ScrollY;
			fixed _Disslove;
			fixed _DissolveCover;
			fixed _DissolveMultiplier;
			fixed _DissolvePow;
			fixed _DissolveOffset;
			fixed4 _DissolveColor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord + frac(half2(_ScrollX, _ScrollY) * _Time.x);
				o.worldPos = mul(_Object2World, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				fixed4 DissolveTex_3 = tex2D(_DissolveTex, i.texcoord1);
				float4 zeroPos = mul(_Object2World, fixed4(0, 0, 0, 1));
				float footOffset = i.worldPos.y - zeroPos.y;
				float headOffset = 1 - footOffset;
				float noda_4 = lerp(footOffset, headOffset, _DissolveOffset);
				half tmpvar_29 = (clamp (( ( _Disslove + ((dot(DissolveTex_3, half4(0.3, 0.59, 0.11, 0)) * noda_4) +noda_4)) - 1.0), 0, 1) * 4);
				half tmpvar_30 = clamp((( 1.0 - tmpvar_29) - _DissolveCover), 0, 1.0);
				half3 tmpvar_31 = ((DissolveTex_3.xyz * _DissolveColor) * _DissolveMultiplier);
				float3 Glow_2 = tmpvar_31;
				clip(tmpvar_29 - _DissolvePow);
				
				float4 result;
				result.xyz = lerp(col.xyz, col.xyz + Glow_2, half3(tmpvar_30, tmpvar_30, tmpvar_30));
				result.w = col.w;
				return result;
			}
		ENDCG
		}
	}
}
