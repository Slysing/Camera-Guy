using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentsMove : MonoBehaviour
{
    public bool Usable = false;
    public GameObject Use;
    Animation anim;
    public Animator floorRotate8;
    public Animator floorRotate9;
    public Animator floorRotate10;
    public Animator floorRotate11;
    public Animator floorRotate12;
    public Animator floorRotate13;
    public Animator floorRotate14;
    public GameObject elevatorCollider;
    public GameObject elevatorCollider2;
    public GameObject elevatorCollider3;


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

            floorRotate8.SetTrigger("rotate");
            floorRotate9.SetTrigger("rotate");
            floorRotate10.SetTrigger("rotate");
            floorRotate11.SetTrigger("rotate");
            floorRotate12.SetTrigger("rotate");
            floorRotate13.SetTrigger("rotate");
            floorRotate14.SetTrigger("rotate");
            elevatorCollider.SetActive(false);
            elevatorCollider2.SetActive(false);
            elevatorCollider3.SetActive(true);

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
    }



}
