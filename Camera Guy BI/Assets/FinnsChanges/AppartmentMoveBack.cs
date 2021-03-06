﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentMoveBack : MonoBehaviour
{

    public bool Usable = false;
    public GameObject Use;
    public GameObject elevatorCollider;
    Animation anim;
    public Animator appartmentMove;

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

            appartmentMove.SetTrigger("moveBack");

        }
    }


    void OnTriggerEnter(Collider other)
    {
        Debug.Log("PlayerEntered");
        Use.SetActive(true);
        Usable = true;
        elevatorCollider.SetActive(true);
    }

    void OnTriggerExit(Collider other)
    {
        Debug.Log("PlayerLeft");
        Use.SetActive(false);
        Usable = false;
        //openDoor.SetTrigger("Door");
    }
}
