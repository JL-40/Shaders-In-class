using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialChanger : MonoBehaviour
{

    bool Textured = true;
    public Renderer render;

    public Material mat1;
    public Material matToon;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();
    }


    public void Setting1()
    {
        render.material.SetFloat("_UseLambert", 1.0f);

        render.material.SetFloat("_UseAmbiant", 0.0f);

        render.material.SetFloat("_UseSpecular", 0.0f);

        render.material = mat1;
    }

    public void Setting2()
    {
        render.material.SetFloat("_UseLambert", 1.0f);

        render.material.SetFloat("_UseAmbiant", 1.0f);

        render.material.SetFloat("_UseSpecular", 0.0f);
    }

    public void Setting3()
    {

        render.material.SetFloat("_UseLambert", 0.0f);

        render.material.SetFloat("_UseAmbiant", 0.0f);

        render.material.SetFloat("_UseSpecular", 1.0f);
    }


    public void Setting4()
    {
        render.material.SetFloat("_UseLambert", 1.0f);

        render.material.SetFloat("_UseAmbiant", 1.0f);

        render.material.SetFloat("_UseSpecular", 1.0f);
    }


    public void Setting5()
    {
        render.material.SetFloat("_UseLambert", 1.0f);

        render.material.SetFloat("_UseAmbiant", 0.0f);

        render.material.SetFloat("_UseSpecular", 0.0f);

        render.material = matToon;

        if (Textured)
            render.material.SetFloat("_UseTexture", 1.0f);
    }

    public void SettingTextureOnOff()
    {
        if (Textured)
        render.material.SetFloat("_UseTexture", 0.0f);
        else
        render.material.SetFloat("_UseTexture", 1.0f);

        Textured = !Textured;
    }

   
}
