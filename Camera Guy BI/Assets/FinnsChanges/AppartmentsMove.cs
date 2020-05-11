using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentsMove : MonoBehaviour
{
    public bool Usable = false;
    public GameObject Use;
    Animation anim;
    public Animator floorRotate9;
    public Animator floorRotate10;
    public Animator floorRotate11;
    public Animator floorRotate12;
    public Animator floorRotate13;
    public Animator floorRotate14;


    void Start()
    {
        Use.SetActive(false);
        anim = GetComponent<Animation>();
        Usable = false;
    }


    void Update()
    {
        if (Input.GetKeyUp(KeyCode.E) && Usable == true)
        {
            Debug.Log("Open");

            floorRotate9.SetTrigger("rotate");
            floorRotate10.SetTrigger("rotate");
            floorRotate11.SetTrigger("rotate");
            floorRotate12.SetTrigger("rotate");
            floorRotate13.SetTrigger("rotate");
            floorRotate14.SetTrigger("rotate");

        }
    }


    void OnTriggerEnter(Collider other)
    {
        Debug.Log("PlayerEntered");
        Use.SetActive(true);
        Usable = true;
    }

    void OnTriggerExit(Collider other)
    {
        Debug.Log("PlayerLeft");
        Use.SetActive(false);
        Usable = false;
        //openDoor.SetTrigger("Door");
    }



}
