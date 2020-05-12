using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentRotateStop : MonoBehaviour
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
    public GameObject enableCollider;
    public GameObject behindWall;

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

            floorRotate8.SetTrigger("stop");
            floorRotate9.SetTrigger("stop");
            floorRotate10.SetTrigger("stop");
            floorRotate11.SetTrigger("stop");
            floorRotate12.SetTrigger("stop");
            floorRotate13.SetTrigger("stop");
            floorRotate14.SetTrigger("stop");
            elevatorCollider.SetActive(false);
            enableCollider.SetActive(true);
            behindWall.SetActive(true);
            Use.SetActive(false);

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
