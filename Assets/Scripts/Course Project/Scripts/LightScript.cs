using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightScript : MonoBehaviour
{

    public bool Alive = true;

    public Material Default;
    public Material Night;
    public Material Dead;

    public CameraScript cs;

    // NEW
    public Material DaySkyBox;
    public Material NightSkyBox;

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Time.deltaTime * 20.0f, 0.0f, 0.0f, Space.Self);
        if (!Alive)
        {
            cs.m_renderMaterial = Dead;
            return;
        }
        if (transform.eulerAngles.x > 180)
        {
            cs.m_renderMaterial = Night;
            RenderSettings.skybox = NightSkyBox; // NEW
        }
        else
        {
            cs.m_renderMaterial = Default;
            RenderSettings.skybox = DaySkyBox; // NEW
        }

    }
}
