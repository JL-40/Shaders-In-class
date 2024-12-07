using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
[RequireComponent(typeof(NavMeshAgent))]
public class EnemyBehaviour : MonoBehaviour
{


    public NavMeshAgent m_Agent;
    public Animator anim;
    public bool hasAnimation = false;

    public Transform Target;

    public bool dangerous = false;
    public float dangerousTimer = 0.0f;

    public GameObject player;

    public PickUpSpawner pickupholder;

    public Renderer mat;
    public Renderer sword;
    public Renderer shield;

    public LightScript ls;
    void Start()
    {
        m_Agent = GetComponent<NavMeshAgent>();
    }
    
    // Update is called once per frame
    void Update()
    {
        if (Target == null)
        {
            DecideTarget();
        }
        
        if (Target != null)
        {
            m_Agent.destination = Target.position;
        }

        DangerousTick();
    }

    void DecideTarget()
    {
        if (dangerous)
        {
            if (player != null) 
            Target = player.transform;
        }
        else
        {
            if (pickupholder.Pickups.Count > 0)
            {
                Target = pickupholder.Pickups[Random.Range(0, pickupholder.Pickups.Count)].transform;
            }
        }
    }

    void DangerousTick()
    {
        if (dangerous)
        {
            dangerousTimer -= Time.deltaTime;
           
            
            if (dangerousTimer < 2.0f)
            {
                mat.material.SetFloat("_RimPower", 8.0f);
                sword.material.SetFloat("_RimPower", 8.0f);
                shield.material.SetFloat("_RimPower", 8.0f);

                mat.material.SetFloat("_doFlash", 1.0f);
                sword.material.SetFloat("_doFlash", 1.0f);
                shield.material.SetFloat("_doFlash", 1.0f);
             
            }
            if (dangerousTimer < 0.0f)
            {
                dangerous = false;

                if (hasAnimation)
                {
                    anim.SetTrigger("EndDanger");
                }

                mat.material.SetFloat("_RimPower", 8.0f);
                sword.material.SetFloat("_RimPower", 8.0f);
                shield.material.SetFloat("_RimPower", 8.0f);

                mat.material.SetFloat("_doFlash", 0.0f);
                sword.material.SetFloat("_doFlash", 0.0f);
                shield.material.SetFloat("_doFlash", 0.0f);

                mat.material.SetColor("_OutlineColor", new Color(1.0f,1.0f,1.0f,1.0f));
                sword.material.SetColor("_OutlineColor", new Color(1.0f, 1.0f, 1.0f, 1.0f));
                shield.material.SetColor("_OutlineColor", new Color(1.0f, 1.0f, 1.0f, 1.0f));
            }
        }

        DecideTarget();
    }

    void OnTriggerEnter(Collider coll)
    {
        if (coll.gameObject.tag == "PlayerUnit")
        {
            if (coll.GetComponent<PlayerUnitBehaviour>().dangerous)
            {
                GameManager.Instance.Score();
                GameManager.Instance.PlayDeathVFX(transform);
                Die();
            }
            else if (dangerous)
            {
                coll.GetComponent<PlayerUnitBehaviour>().Die();
                ls.Alive = false;
            }
        }
    }

    void Die()
    {
        Destroy(this.gameObject);
    }
}
