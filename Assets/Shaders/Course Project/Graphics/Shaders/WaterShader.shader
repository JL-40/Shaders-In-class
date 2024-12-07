Shader "Sorcery/WaveFromOriginPoint"
{
    Properties
    {
        _MainTex ("Water Texture", 2D) = "white" {}
        _FoamTex ("Foam Texture", 2D) = "white" {}
        [MaterialToggle] _UseTexture ("UseTexture", float) = 0
        _FoamColor ("Foam Color", Color) = (0,0,0,1) 
        _FoamMag ("Foam Height", Range(-0.1,0.1)) = 0
        _FoamOpac ("Foam Threshold", Range(0,1)) = 0


        _PointX("PointX", Range(-1, 1)) = 0
        _PointY("PointY", Range(-1, 1)) = 0

        
        _Amplitude ("Amplitude", float) = 0.5
        _Frequency ("Frequency", float) = 1.0
        _Speed ("Speed", float) = 1.0

        _ScrollX ("ScrollX", Range(-5,5)) = 1
        _ScrollY ("ScrollY", Range(-5,5)) = 1
    }
    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" 

            
            float _Amplitude;
            float _Frequency;
            float _Speed;

            float _PointX;
            float _PointY;

            float _ScrollX;
            float _ScrollY;

            float _UseTexture;
            sampler2D _MainTex;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;  
            };

            
            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float distance : TEXCOORD1;
            };

            
            v2f vert(appdata v)
            {
                v2f o;

                

                float2 Origin = float2(_PointX, _PointY);  

                
                float2 relativeToOrigin = v.uv * 2.0 - 1.0;  


                //Should get us the distance this vertex is from the wave's origin point.
                float2 diff = relativeToOrigin - Origin;
                float distance = sqrt(dot(diff, diff));

                
                float waveHeight = sin(distance * _Frequency + _Time.y * _Speed) * _Amplitude;
                //I took out the second peice for simplicity. visually it doesnt seem to matter much.

                v.vertex.y += waveHeight;


                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.distance = distance; //this was for testing...ill leave it in, just in case it breaks before our performance later.

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                _ScrollX *= _Time;
                _ScrollY *= _Time;
                half4 water;
                if (_UseTexture)
                water = (tex2D (_MainTex, i.uv + float2(_ScrollX, _ScrollY)));
                else
                water = (0,0,1,1);
                //return half4(i.distance, i.distance, i.distance, 1.0); //(old visualisation Code)
                half4 texColor = tex2D(_MainTex, i.uv);

                return water;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" 

            
            float _Amplitude;
            float _Frequency;
            float _Speed;

            float _PointX;
            float _PointY;

            float _ScrollX;
            float _ScrollY;

            float _UseTexture;
            sampler2D _FoamTex;
            float4 _FoamColor;
            float _FoamMag;
            float _FoamOpac;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;  
            };

            
            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float distance : TEXCOORD1;
                float highIncrease : TEXCOORD2;
            };

            
            v2f vert(appdata v)
            {
                v2f o;

                _ScrollX *= _Time;
                _ScrollY *= _Time;

                float2 Origin = float2(_PointX, _PointY);  

                
                float2 relativeToOrigin = v.uv * 2.0 - 1.0;  


                //Should get us the distance this vertex is from the wave's origin point.
                float2 diff = relativeToOrigin - Origin;
                float distance = sqrt(dot(diff, diff));

                
                float waveHeight = sin(distance * _Frequency + _Time.y * _Speed) * _Amplitude;
                //I took out the second peice for simplicity. visually it doesnt seem to matter much.

                o.highIncrease = waveHeight + _FoamMag;
                v.vertex.y += o.highIncrease;
                

                //float foamAtVertex = tex2D (_FoamTex, v.uv + float2(_ScrollX, _ScrollY)).a;
                
                //if (foamAtVertex > 0)
                
                
               // v.vertex.y += 0.02;

         
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.distance = distance; //this was for testing...ill leave it in, just in case it breaks before our performance later.
                

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                _ScrollX *= _Time /2 ;
                _ScrollY *= _Time /2;
                half4 water;
                float foam;
                
                if (_UseTexture)
                {
                water = _FoamColor * (tex2D (_FoamTex, i.uv + float2(_ScrollX, _ScrollY)));
                foam = tex2D(_FoamTex, i.uv + float2(_ScrollX, _ScrollY)).a;
                }
                else
                {
                water = _FoamColor;
                foam = 0.5;
                }
                

                return half4(water.r,water.g,water.b, foam * _FoamOpac); 
               
            }
            ENDCG


            ZWrite Off

            // This one line is aided by generative AI.
            Blend SrcAlpha OneMinusSrcAlpha

            ColorMask RGB
        }
    }
}
