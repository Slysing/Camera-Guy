using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Elevator : MonoBehaviour
{


    public bool Usable = false;
    public GameObject Use;
    public GameObject Collider;
    Animation anim;
    public Animator moveElevator;


    void Start()
    {
        Use.SetActive(false);
        anim = GetComponent<Animation>();
    }


    void Update()
    {
        if (Input.GetKeyUp(KeyCode.E) && Usable == true)
        {
            Debug.Log("Moving");

            moveElevator.SetTrigger("ElevatorMove");

        }
    }


    void OnTriggerEnter(Collider other)
    {
        Debug.Log("PlayerEntered");
        Use.SetActive(true);
        Collider.SetActive(true);
        Usable = true;
    }

    void OnTriggerExit(Collider other)
    {
        Debug.Log("PlayerLeft");
        Use.SetActive(false);
        Usable = false;
        //moveElevator.SetTrigger("ElevatorMove");
    }
}
