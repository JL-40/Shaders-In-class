Shader "TintRimShaderToon"
{
    Properties
    {
        [MaterialToggle] _UseTexture ("UseTexture", float) = 0
        _MainTex("Texture", 2D) = "white" {}
        _ColorMain("MainColor", Color) = (1,1,1,1)
        _ColorTint("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower("Rim Power", Range(0.5,8.0)) = 3.0

        [MaterialToggle] _doFlash ("flashing", float) = 0


        [MaterialToggle] _doOutline ("EnableOutline", float) = 0
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _DefaultOutline ("Default", float) = 0.085


        [MaterialToggle] _doToon ("EnableToon", float) = 0
        _RampTex("TextureRamp", 2D) = "white" {}
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }

            // Toonshading
            CGPROGRAM
                #pragma surface surf ToonRamp finalcolor:mycolor 
   
            struct Input {
                float2 uv_MainTex;
                float3 viewDir;
                };
        fixed4 _ColorTint;
        float4 _RimColor;
        float _RimPower;

        float _doFlash;
        
        float _doToon;
        sampler2D _RampTex;
        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot (s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;
            float4 c;
            if (_doToon)
            {
            
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            }
            else
            c = float4(0,0,0,1);
            return c;
        }

        void mycolor(Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }

        float _UseTexture;
        fixed4 _ColorMain;
        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            if (_UseTexture)
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb; // Apply texture
            else
            o.Albedo = _ColorMain;
            //	half rim = dot(normalize(IN.viewDir), o.Normal);
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            //o.Emission = _RimColor.rgb * rim;
            if (_doFlash)
            {
            o.Emission = _RimColor.rgb * pow (rim, _RimPower * sin(_Time.z * 10)); // Change the rim power over time to create flashing effect
            }
            else
            {
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); // Constant rim power
            }
        }
        ENDCG

        Pass
        {
            Cull Front

            // Outline on power up
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                fixed4 pos : SV_POSITION;
                fixed4 color : COLOR;
            };

            float _doOutline;
            float _doFlash;

            float4 _OutlineColor;
            float _DefaultOutline;

            v2f vert( appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                if (_doOutline)
                    {
                float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 offset = TransformViewToProjection(norm.xy);

                if (!_doFlash)
                o.pos.xy += offset * o.pos.z * _DefaultOutline;
                    }
                o.color = _OutlineColor;
                return o;
            }

            fixed4 frag (v2f i ) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
        }
    Fallback "Diffuse"
}