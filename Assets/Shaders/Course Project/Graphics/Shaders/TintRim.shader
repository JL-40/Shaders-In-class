Shader "TintRimShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ColorTint("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower("Rim Power", Range(0.5,8.0)) = 3.0

        [MaterialToggle] _doFlash ("flashing", float) = 0


        [MaterialToggle] _doOutline ("EnableOutline", float) = 0
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _DefaultOutline ("Default", float) = 0.085
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

        float _doFlash;
        

        

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
            if (_doFlash)
            {
            o.Emission = _RimColor.rgb * pow (rim, _RimPower * sin(_Time.z * 10));
            }
            else
            {
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            }
        }
        ENDCG

        Pass
        {
            Cull Front

            // Create Outline
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