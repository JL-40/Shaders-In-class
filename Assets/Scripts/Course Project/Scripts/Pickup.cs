using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{


    public GameObject Spawner;

    public string m_Tag = "EnemyUnit";
    public string p_Tag = "PlayerUnit";

    public Renderer mat;
    public float Opacity;
    public bool glowDown;

    void Update()
    {
        if (glowDown)
            Opacity -= Time.deltaTime;
        else
            Opacity += Time.deltaTime;
        if (Opacity < 0.3f)
        {
            glowDown = false;
        }
        if (Opacity > 1.0f)
        {
            Opacity = 1.0f;
            glowDown = true;
        }

        mat.material.SetFloat("_Opacity", Opacity);

    }

    void OnTriggerEnter(Collider other)
    {
        Debug.Log("Test- Something hit a pickup");
        if (other.gameObject.tag == m_Tag)
        {
            Spawner.GetComponent<PickUpSpawner>().Pickups.Remove(this.gameObject);
            Destroy(gameObject);
            other.GetComponent<EnemyBehaviour>().dangerous = true;
            other.GetComponent<EnemyBehaviour>().dangerousTimer = 10.0f;

            if (other.GetComponent<EnemyBehaviour>().hasAnimation)
            {
                other.GetComponent<EnemyBehaviour>().anim.SetTrigger("Danger");
            }

            other.GetComponent<EnemyBehaviour>().mat.material.SetFloat("_RimPower", 0.5f);

            other.GetComponent<EnemyBehaviour>().mat.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
            other.GetComponent<EnemyBehaviour>().sword.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
            other.GetComponent<EnemyBehaviour>().shield.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
        }
        else if (other.gameObject.tag == p_Tag)
        {

            Spawner.GetComponent<PickUpSpawner>().Pickups.Remove(this.gameObject);
            Destroy(gameObject);
            other.GetComponent<PlayerUnitBehaviour>().dangerous = true;
            other.GetComponent<PlayerUnitBehaviour>().dangerousTimer = 10.0f;
            other.GetComponent<PlayerUnitBehaviour>().anim.SetTrigger("Danger");
            other.GetComponent<PlayerUnitBehaviour>().mat.material.SetFloat("_RimPower", 0.5f);


            other.GetComponent<PlayerUnitBehaviour>().mat.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
            other.GetComponent<PlayerUnitBehaviour>().sword.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
            other.GetComponent<PlayerUnitBehaviour>().shield.material.SetColor("_OutlineColor", new Color(1.0f, 0.0f, 0.0f, 1.0f));
        }
    }
}
