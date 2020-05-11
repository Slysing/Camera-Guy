using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Elevator_Riley : MonoBehaviour
{
    public Transform elevatorTransform;
    public float minHeight;
    public float maxHeight;

    bool hasPlayer;
    bool moving;
    bool movingUp;

   public float movementSpeed = 5;

    void Start()
    {
        if (elevatorTransform == null)
            elevatorTransform = transform;
    }


    void Update()
    {

        // Temp - to be replaced with dialogue system
        if(Input.GetKeyDown(KeyCode.H))
        {
            UseElevator();
        }



        if (moving)
        {
            float newHeight = elevatorTransform.position.y;

            if (movingUp)
            {
                newHeight += movementSpeed * Time.deltaTime;
                if (newHeight > maxHeight)
                    moving = false;
            }
            else
            {
                newHeight -= movementSpeed * Time.deltaTime;
                if (newHeight < minHeight)
                    moving = false;
            }

            newHeight = Mathf.Clamp(newHeight, minHeight, maxHeight);

            elevatorTransform.position = new Vector3(elevatorTransform.position.x, newHeight, elevatorTransform.position.z);

        }
    }


    public void UseElevator()
    {
        if (hasPlayer && !moving)
        {
            ToggleDirection();
            moving = true;
        }
    }


    void ToggleDirection()
    {
        movingUp = !movingUp;
    }

    void OnTriggerEnter (Collider collider)
    {
        if (collider.transform.CompareTag("Player"))
        {
            hasPlayer = true;
            collider.transform.SetParent(transform);
        }
       Debug.Log("Enter");
    }  
    void OnTriggerExit (Collider collider)
    {
        if (collider.transform.CompareTag("Player"))
        {
            hasPlayer = false;
            collider.transform.SetParent(null);
        }
            Debug.Log("Exit");
    }  

}
