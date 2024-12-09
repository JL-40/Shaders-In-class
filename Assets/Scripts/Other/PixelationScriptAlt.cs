using UnityEngine;

public class PixelationScriptAlt : MonoBehaviour
{
    public Material m_pixelateMat;
    public int pixelDensity = 64;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Vector2 aspectRatioData;
        if (Screen.height > Screen.width)
        {
            aspectRatioData = new Vector2((float)Screen.width / Screen.height, 1);
        }
        else
        {
            aspectRatioData = new Vector2(1, (float)Screen.height / Screen.width);
            m_pixelateMat.SetVector("_AspectRatioMultiplier", aspectRatioData);
            m_pixelateMat.SetInt("_PixelDensity", pixelDensity);
            Graphics.Blit(source, destination, m_pixelateMat);
        }
    }
}
