using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WreckingBall : MonoBehaviour
{
  public  bool destroyOnContact = true;
    public float lifeTimer = 1;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        lifeTimer -= Time.deltaTime;
        if (lifeTimer <= 0)
        {
            Destroy(gameObject);
        }

    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.GetComponent<Rigidbody>() != null)
        {
            if (collision.transform.GetComponent<Rigidbody>().isKinematic)
            {
                collision.transform.GetComponent<Rigidbody>().isKinematic = false;
                collision.transform.GetComponent<Rigidbody>().AddExplosionForce(100, transform.position, 10); 
         //       AudioManager.Instance.WreckIT();
            }
        }

        if (destroyOnContact)
        Destroy(gameObject);


    }


}
