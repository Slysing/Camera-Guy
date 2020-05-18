using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerEvent : MonoBehaviour
{
   public UnityEngine.Events.UnityEvent triggerEvent;
    public string neededTag;
    public GameObject cashierCollider;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag(neededTag)) {
            triggerEvent.Invoke();
            cashierCollider.name = "Cashier_02";
        }
    }
}
