using System.Collections;
using System.Collections.Generic;

using UnityEngine;

public class LightChangeScript : MonoBehaviour
{
    public static LightChangeScript instance;

    public List<MaterialChanger> Objects;

    public Renderer Player;

    public List<Renderer> Enemies;

    public Renderer water;

    public Transform TileOwner;


    bool Textured = true;

    bool Toon = false;

    private void Awake()
    {
        if (instance != this && instance != null)
        {
            Destroy(gameObject);
        }
        instance = this;
    }

    void Start()
    {
        foreach (Transform child in TileOwner)
        {
            child.position = (new Vector3(child.position.x, child.position.y + Random.Range(0.0f, 2.5f),child.position.z));
            Objects.Add(child.GetComponent<MaterialChanger>());

        }
    }


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Alpha1))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.Setting1();
            }
        }

        if (Input.GetKey(KeyCode.Alpha2))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.Setting2();
            }
        }

        if (Input.GetKey(KeyCode.Alpha3))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.Setting3();
            }
        }

        if (Input.GetKey(KeyCode.Alpha4))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.Setting4();
            }
        }

        if (Input.GetKey(KeyCode.Alpha5))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.Setting5();
            }

            if (Toon)
            {
                if (Player!=null)
                 Player.material.SetFloat("_doToon", 0.0f);
            }
            else
            {
                if (Player != null)
                    Player.material.SetFloat("_doToon", 1.0f);
            }

            foreach (Renderer ren in Enemies)
            {
                if (ren == null) continue;


                if (Textured)
                {
                    ren.material.SetFloat("_doToon", 0.0f);
                }
                else
                {
                    ren.material.SetFloat("_doToon", 1.0f);
                }
            }

            Toon = !Toon;
        }


        if (Input.GetKeyDown(KeyCode.Alpha6))
        {
            foreach (MaterialChanger obj in Objects)
            {
                obj.SettingTextureOnOff();
            }

            if (Textured)
            {
                Player.material.SetFloat("_UseTexture", 0.0f);
            }
            else
            {
                Player.material.SetFloat("_UseTexture", 1.0f);
            }

            foreach (Renderer ren in Enemies)
            {
                if (ren == null) continue;
                    
               
                if (Textured)
                {
                    ren.material.SetFloat("_UseTexture", 0.0f);
                }
                else
                {
                    ren.material.SetFloat("_UseTexture", 1.0f);
                }
            }

            if (Textured)
            {
                water.material.SetFloat("_UseTexture", 0.0f);
            }
            else
            {
                water.material.SetFloat("_UseTexture", 1.0f);
            }
            





            Textured = !Textured;
        }
    }
}
