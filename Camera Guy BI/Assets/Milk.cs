using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
public class Milk : MonoBehaviour
{

    Transform currentTarget;
    private NavMeshAgent nav;

    private float speed;

    // Start is called before the first frame update
    void Start()
    {
        nav = GetComponent<NavMeshAgent>();
        speed = nav.speed;
        speed = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if (nav != null)
        {
            if (currentTarget != null)
            {
                nav.destination = currentTarget.position;
            }
        }
    }



    public void SetTarget(Transform target)
    {
    //    nav.enabled = true;
        currentTarget = target;
    }

    public void AvtivateNav()
    {
        nav.speed = speed;
    }

    public void ForgetTarget()
    {
        nav.enabled = false;
        currentTarget = null;
    }

    public void SetStoppingDistance(float distance)
    {
        nav.stoppingDistance = distance;
    }
}
