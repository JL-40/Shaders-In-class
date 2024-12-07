using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpSpawner : MonoBehaviour
{
    public List<GameObject> Pickups = new List<GameObject>();

    public float TimeBetweenSpawns = 10.0f;
    public float SpawnTimer = 0.0f;

    public GameObject PickupRef;

    void Start()
    {
        SpawnTimer = 1.0f;

    }

    void Update()
    {
        SpawnTimer -= Time.deltaTime;

        if (SpawnTimer <= 0.0f)
        {
            CreatePickup();
            SpawnTimer = TimeBetweenSpawns;
        }
    }


    void CreatePickup()
    { 
        GameObject newPickup = Instantiate(PickupRef, new Vector3(Random.Range(-30,30),0.0f,Random.Range(-30,30)), Quaternion.identity, this.transform);
        Pickups.Add(newPickup);
        newPickup.GetComponent<Pickup>().Spawner = this.gameObject;

    }
}
