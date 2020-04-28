using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public CharacterController controller;
    public Camera cam;
    //player movements
    public float speed = 12f;
    public float sprintSpeed = 12f;
    public float gravity = -9.81f;
    public float jumpHeight = 3f;
    public bool canMove = true;
    
  
    //Gravity
    public Transform groundCheck;
    public float groundDistance = 0.4f;
    public LayerMask groundMask;

    //raycasting
    public LayerMask layer;

    Vector3 Velocity;
    public bool isGrounded;


    public GameObject arm;
    public GameObject ball;
    void Update()
    {
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);

        if(isGrounded && Velocity.y < 0)
        {
            Velocity.y = -2f;
        }

        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");

        Vector3 move = transform.right * x + transform.forward * z;

        float moveSpeed = canMove? speed:0;
        if (Input.GetKey(KeyCode.LeftShift))
        {
            moveSpeed = sprintSpeed;
        }

        controller.Move(move * moveSpeed * Time.deltaTime);

        if (Input.GetButtonDown("Jump") && isGrounded)
        {
            Velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
            Debug.Log("Jump");
        }

        Velocity.y += gravity * Time.deltaTime;
       
        controller.Move(Velocity * Time.deltaTime);

        //ray casting

        if (Input.GetMouseButtonDown(0))
        {
            // tracks mouse movement
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 50, layer))
            {
                Debug.Log("Hit: " + hit.transform.gameObject.name);

                // tells the Animation controller script to activate once clicked on
                AnimationController animCon = hit.transform.GetComponent<AnimationController>();

                if (animCon)
                {
                    animCon.Run();

                }

            }


            GameObject obj = Instantiate(ball, arm.transform.position + arm.transform.forward, arm.transform.rotation);
            obj.GetComponent<Rigidbody>().AddForce(arm.transform.forward * 1000);
        }


        if (Input.GetMouseButtonDown(1))
        {
            // sets up actions that ocour when the player clicks on stuff with the passive_Enemy script and ignores the Players collider
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 50, layer))
            {
                AnimationController animCon = hit.transform.GetComponent<AnimationController>();

                if (animCon)
                {
                    animCon.Run();

                }

            }
        }



    }
}
