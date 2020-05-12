using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class disableAppartments : MonoBehaviour
{
    
    public GameObject floors;
    public GameObject barrier;
    public GameObject foyer;


    void OnTriggerEnter(Collider other)
    {
        Debug.Log("PlayerEntered");

        barrier.SetActive(false);
        foyer.SetActive(true);
    }

    void OnTriggerExit(Collider other)
    {
        Debug.Log("PlayerLeft");
        floors.SetActive(false);
    }


}
