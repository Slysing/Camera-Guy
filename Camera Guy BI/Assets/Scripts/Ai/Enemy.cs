using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{

    NavMeshAgent nav;
    GameObject player;

    void Start()
    {
        player = FindObjectOfType<PlayerMovement>().gameObject;
        nav = GetComponent<NavMeshAgent>();
    }


    void Update()
    {
        if (Vector3.Distance(transform.position, player.transform.position) < 8)
            nav.destination = player.transform.position;
    }
}
