using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppartmentsMoveUp : MonoBehaviour
{


    public bool Usable = false;
    public GameObject Use;
    Animation anim;
    public Animator floorRotate14;
    public GameObject elevatorCollider;
    public GameObject enableCollider;


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

            floorRotate14.SetTrigger("up");
            elevatorCollider.SetActive(false);
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
