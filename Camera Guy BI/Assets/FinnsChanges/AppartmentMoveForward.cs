using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentMoveForward : MonoBehaviour
{
    public bool Usable = false;
    public GameObject Use;
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

            appartmentMove.SetTrigger("moveClose");

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
