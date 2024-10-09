Shader "Tutorial/NormalMapping+Rim"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _myTex ("Texture", 2D) = "white" {}
        _myBump ("Texture Map", 2D) = "Bump" {}
        _mySlider ("Bump factor", Range(0,10)) = 1 
        _myCube ("Cube map", CUBE) = ""{}

        _rimColor ("Rim Color", Color) = (0.5,0.5,0.5,0.0)
        _rimPower ("Rim edge power", Range(0.0,8.0)) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
     
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        //#pragma target 3.0

        sampler2D _myTex;
        sampler2D _myBump;
        samplerCUBE _myCube;
        fixed4 _Color;
        half _mySlider;

        float4 _rimColor;
        float _rimPower;

        struct Input
        {
            float2 uv_myTex;
            float2 uv_myBump;
            float3 viewDir;
            float3 worldRefl; INTERNAL_DATA
        };

   
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
             o.Albedo = tex2D (_myTex, IN.uv_myTex).rgb;
             o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));
             o.Normal *= float3(_mySlider,_mySlider,1);
             
             float3 EmissionVec = texCUBE(_myCube, WorldReflectionVector (IN, o.Normal)).rgb;

            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = rim> 0.75 ? _rimColor.rgb : EmissionVec;
             

             
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
