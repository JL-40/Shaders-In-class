using UnityEngine;

[ExecuteInEditMode]
public class DecalOnOff : MonoBehaviour
{
    Material mat;
    bool showDecal = false;

    void OnMouseDown()
    {
        showDecal = !showDecal;
        if (showDecal)
            mat.SetFloat("_ShowDecal", 1);
        else
            mat.SetFloat("_ShowDecal", 0);
    }

    // Start is called before the first frame update
    void Start()
    {
        mat = GetComponent<Renderer>().sharedMaterial;
    }
}
