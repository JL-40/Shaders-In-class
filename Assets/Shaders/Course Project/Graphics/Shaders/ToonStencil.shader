Shader "Sorcery/ToonShadeStencil"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}

        _MainTex ("Texture", 2D) = "white" {}
        [MaterialToggle] _UseTexture ("Use Tex", float) = 0
    }
    SubShader
    {
        Stencil
        {
            Ref 1
            Comp NotEqual
            Pass Keep
        }

        CGPROGRAM
        #pragma surface surf ToonRamp

        struct Input
        {
            float2 uv_MainTex;
        };

        
        float4 _Color;
        sampler2D _RampTex;

        sampler2D _MainTex;
        float _UseTexture;

        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot (s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }


        void surf (Input IN, inout SurfaceOutput o)
        {
            if (_UseTexture)
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            else
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
