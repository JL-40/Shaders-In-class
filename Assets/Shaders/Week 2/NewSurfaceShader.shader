Shader "Week2/ComputerGraphicShaders"
{
  Properties {
	  _myColor ("Sample Color", Color) = (1,1,1,1)
	  _myEmission ("Sample Emission", Color) = (1,1,1,1)
	  _myNormal ("Sample Normal", Color) = (1,1,1,1)
  }

  SubShader {
	  CGPROGRAM
	  #pragma surface surf Lambert

	  fixed4 _myColor;
	  fixed4 _myEmission;
	  fixed4 _myNormal;

	  struct Input {
		  float2 uv_myTex;
	  };

	  void surf (Input IN, inout SurfaceOutput o) {
		  o.Albedo = _myColor.rgb;
		  o.Emission = _myEmission.rgb;
		  o.Normal = _myNormal.rgb;
		  }

		  ENDCG
  }
  FallBack "Diffuse"
}
