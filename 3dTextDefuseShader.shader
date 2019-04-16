Shader "GUI/3D Text Defuse Shader" {
	Properties
	{
		_FontTex("Font Texture", 2D) = "white" {}
		_Cutoff("Shadow Alpha cutoff", Range(0.01,0.99)) = 1.0
	}
	
	SubShader
	{
		CGPROGRAM
		sampler2D _FontTex;
		half4 _Color;
		#pragma surface surf SimpleLambert alphatest:_Cutoff        

		half4 LightingWrapLambert(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
			c.a = s.Alpha;
			return c;
		}

		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(-s.Normal, lightDir);
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * ((NdotL + 1) * atten);
			c.a = s.Alpha;
			return c;
		}

		struct Input
		{
			float2 uv_FontTex;
			half4 color : Color;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			half alpha = tex2D(_FontTex, IN.uv_FontTex).a;
			o.Alpha = alpha;
			o.Albedo = IN.color.rgb;
		}

		ENDCG
	}
	
	Fallback "Transparent/Cutout/Diffuse"
}