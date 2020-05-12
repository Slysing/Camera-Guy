using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class toggleOn : MonoBehaviour
{

    public GameObject appartment;



    void Start()
    {
        
    }

    public void EventOn(float theValue)
    {
        Debug.Log("PrintFloat is called with a value of " + 1);
        appartment.SetActive(false);
    }


    public void EventOff(float theValue)
    {
        Debug.Log("PrintFloat is called with a value of " + 2);
        appartment.SetActive(true);
    }


}
