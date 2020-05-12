using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class toggleAnim : MonoBehaviour
{



    //public GameObject floor;
    public Animator floorUp;


    void Start()
    {

    }

    public void EventOn(float theValue)
    {
        Debug.Log("PrintFloat is called with a value of " + 3);
        floorUp.SetTrigger("up");
    }


    //public void EventOff(float theValue)
    //{
    //    Debug.Log("PrintFloat is called with a value of " + 2);
    //    appartment.SetActive(true);
    //}


    void Update()
    {
        


    }


}
