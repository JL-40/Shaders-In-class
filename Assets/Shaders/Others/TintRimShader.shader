Shader "Ivan/TintRimShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ColorTint("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower("Rim Power", Range(0.5,8.0)) = 3.0
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }
            CGPROGRAM
            #pragma surface surf Lambert finalcolor:mycolor
            struct Input {
                float2 uv_MainTex;
                float3 viewDir;
                };
        fixed4 _ColorTint;
        float4 _RimColor;
        float _RimPower;
        void mycolor(Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            //	half rim = dot(normalize(IN.viewDir), o.Normal);
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            //o.Emission = _RimColor.rgb * rim;
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
        }
    Fallback "Diffuse"
}