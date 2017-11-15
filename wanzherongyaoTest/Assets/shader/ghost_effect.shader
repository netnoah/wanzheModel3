
Shader "T/Ghost" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("_MainTex", 2D) = "white" {}
		_AlphaTex ("_AlphaTex", 2D) = "white" {}
		_CupTex ("CubTex", 2D) = "white" {}
		_ScrollX ("_ScrollX", float ) = 1.0
		_ScrollY ("_ScrollY", float ) = 1.0
		_ColorLevel ("_ColorLevel", float) = 1.0
		_Level ("_Level", float) = 1.0
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
				half3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				half2 texcoord1 : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			sampler2D _CupTex;
			fixed4 _Color;
			fixed _ScrollX;
			fixed _ScrollY;
			fixed _ColorLevel;
			fixed _Level;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord + frac(half2(_ScrollX, _ScrollY) * _Time.x);
				half3 n_normal = normalize(v.normal);
				o.texcoord1 = mul(half4(n_normal, 0), _World2Object).xyz;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				col.xyz = tex2D(_MainTex, i.texcoord);
				col.a = tex2D(_AlphaTex, i.texcoord).x;
				half2 normal = normalize(i.texcoord1).xy * 0.5 + 0.5;
				half4 cupTex = tex2D(_CupTex, normal);
				
				half4 result;
				result.xyz = (col * _ColorLevel * _Color + cupTex * _Level).xyz;
				result.w = col.w * dot(cupTex , half4(0.5, 0.5, 0.5, 0)) * _Color.w * 2.0;
				return result;
			}
		ENDCG
		}
	}
}
