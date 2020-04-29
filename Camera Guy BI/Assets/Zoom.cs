using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Zoom : MonoBehaviour

{
    public PlayerMovement player;
    float targetFOV;
    bool zoomingIn;

    Camera cam;
    void Start()
    {
        cam = GetComponent<Camera> ();
        targetFOV = 60;
    }

    void Update()
    {
        if (Input.GetAxis ("Mouse ScrollWheel") > 0)
        {
         //  cam.fieldOfView = Mathf.Clamp(cam.fieldOfView-1,20,60);
         targetFOV = 20;
         player.canMove = false;
        }
        if (Input.GetAxis ("Mouse ScrollWheel") < 0)
        {
        //   cam.fieldOfView = Mathf.Clamp(cam.fieldOfView+1,20,60);
        targetFOV = 60;
        player.canMove = true;
        }        

        cam.fieldOfView = Mathf.Lerp(cam.fieldOfView,targetFOV,0.05f);
    }
}
