using UnityEngine;

public class PixelationScript : MonoBehaviour
{
    public Material m_pixelateMaterial;
    public int pixelDensity = 200;

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
        }
        m_pixelateMaterial.SetVector("_AspectRatioMultipler", aspectRatioData);
        m_pixelateMaterial.SetInt("_pixelDensity", pixelDensity);
        Graphics.Blit(source, destination, m_pixelateMaterial);
    }
}