using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CasteFall : MonoBehaviour
{
    Rigidbody my_rb;
    Collider my_collider;

    Rigidbody[] rbs;
    Collider[] colliders;

    bool frozen;
    // Start is called before the first frame update
    void Start()
    {
        frozen = false;
        my_rb = GetComponent<Rigidbody>();
        my_collider = GetComponent<Collider>();

        rbs = GetComponentsInChildren<Rigidbody>();
        colliders = GetComponentsInChildren<Collider>();


        for (int i = 0; i < rbs.Length; ++i)
        {
            rbs[i].isKinematic = true;
            rbs[i].constraints = RigidbodyConstraints.None;
        }

       // for (int i = 0; i < colliders.Length; ++i)
       // {
       //     colliders[i].enabled = false;
       // }

        my_rb.isKinematic = false;
        my_collider.enabled = true;
    }

    // Update is called once per frame
    void Update()
    {

    }


    //  private void OnCollisionEnter(Collision collision)
    //  {
    //      if (!frozen)
    //      {
    //          frozen = true;
    //
    //          for (int i = 0; i < rbs.Length; ++i)
    //          {
    //              rbs[i].isKinematic = false;
    //          }
    //
    //          for (int i = 0; i < colliders.Length; ++i)
    //          {
    //              colliders[i].enabled = true;
    //          }
    //
    //          my_rb.isKinematic = true;
    //          my_collider.enabled = false;
    //      }
    //  }
}
