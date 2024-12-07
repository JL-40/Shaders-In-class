Shader "Sorcery/StencilBufferFront"
{
    Properties
    {
        
        _MainTex ("Stencil Texture", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "Queue" = "Geometry-1" }
        
        ColorMask 0
        ZWrite Off

        Stencil
        {
            Ref 1
            Comp always
            Pass replace
        }


        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
        
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
