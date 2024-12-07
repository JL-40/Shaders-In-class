Shader "Sorcery/MainShadeWorld"{
    Properties {
       
        _Color("Color", Color) = (1.0,1.0,1.0)


        [MaterialToggle] _UseLambert ("Use Lambert", float) = 0
        [MaterialToggle] _UseAmbient ("Use Ambience", float) = 0


        [MaterialToggle] _UseSpecular ("Use Specular", float) = 0
        _SpecColor("HighlightColor", Color) = (1.0,1.0,1.0)
        _Shininess("Shininess", Float) = 10


        [MaterialToggle] _UseTexture ("Use Tex", float) = 0
        _MainTex("Texture", 2D) = "white" {}


    }
    SubShader {


        Pass{
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            // user defined variables
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;


            float _UseAmbient;
            float _UseLambert;
            float _UseSpecular;

            float _UseTexture;
            uniform sampler2D _MainTex;



            // unity defined variables
            uniform float4 _LightColor0;


            



            struct Input {
                float2 uv_myDiffuse;
                //float2 uv_myBump;
            };


            struct vertexInput {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float2 uv: TEXCOORD0;

            };


            struct vertexOutput {
                float4 pos: SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
                float4 col: COLOR;
                float2 uv: TEXCOORD2;
            };






            // vertex functions
            vertexOutput vert(vertexInput v) {
                vertexOutput o;

               
                float3 normalDirection = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);


                float3 lightDirection;
                float atten = 1.0;


                lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                if (_UseAmbient)
                {
                    float3 diffuseReflection = atten * _LightColor0.xyz*max(0.0,dot(normalDirection, lightDirection));


                    float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;


                    o.col = float4(lightFinal*_Color.rgb, 1.0);
                }
                else if (_UseLambert)
                {
                    float3 diffuseReflection = atten * _LightColor0.xyz * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));


                    o.col = float4(diffuseReflection, 1.0);
                }
                o.pos = UnityObjectToClipPos(v.vertex);
                if (_UseSpecular)
                {
                    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                    o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
                    o.pos = UnityObjectToClipPos(v.vertex);

                    
                }

                o.uv = v.uv;

                return o;
            }


            // fragment function
            float4 frag(vertexOutput i) : COLOR
            {
                
                float3 normalDirection = i.normalDir;
                float atten = 1.0;


                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));


                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) -i.posWorld.xyz));


                float3 lightSeeDirection = max(0.0,dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);


                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;


                float3 lightFinal = (0,0,0);
                
                if (_UseSpecular)
                {
                    lightFinal += specularReflection * _SpecColor.rgb;
                }
               
                if (_UseAmbient)
                {
                lightFinal += diffuseReflection + UNITY_LIGHTMODEL_AMBIENT * _Color.rgb;
                }
                else if (_UseLambert)
                {
                lightFinal += diffuseReflection * _Color.rgb;
                }
               
                float4 textureColor = (1,1,1,1);
                if (_UseTexture)
                {
                    textureColor = tex2D(_MainTex, i.uv);
                }
               
                return float4(lightFinal, 1.0) * textureColor;
                


            }


           






            ENDCG
    }
}
}
