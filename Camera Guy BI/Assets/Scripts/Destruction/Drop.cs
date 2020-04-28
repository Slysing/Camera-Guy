using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class Drop : MonoBehaviour
{
    public float delay = 0.1f;
    private bool stable;
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        stable = false;

        rb = GetComponent<Rigidbody>();

    }

    // Update is called once per frame
    void Update()
    {
        if (rb.velocity.magnitude == 0)
        {
            delay -= Time.deltaTime;
            if (delay <= 0)
            {
                rb.isKinematic = true;
                enabled = false;
            }
        }
    }

}
