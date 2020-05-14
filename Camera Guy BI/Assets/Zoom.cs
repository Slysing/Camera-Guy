using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Zoom : MonoBehaviour

{
    public PlayerMovement player;
    private float targetFOV;
    bool zoomingIn;
    private DialogueManager dm;
    private float defaultFOV;
    private bool zoom = false;

    Camera cam;

    private void Awake()
    {
        cam = GetComponent<Camera>();
        targetFOV = cam.fieldOfView;
        dm = FindObjectOfType<DialogueManager>();
        defaultFOV = cam.fieldOfView;
    }

    void Update()
    {
        if (Input.GetAxis ("Mouse ScrollWheel") > 0 && !dm.showingDialogue && !zoom)
        {
            //  cam.fieldOfView = Mathf.Clamp(cam.fieldOfView-1,20,60);
            targetFOV = 20;
            player.canMove++;
            zoom = true;
        }
        if (Input.GetAxis ("Mouse ScrollWheel") < 0 && zoom)
        {
            //   cam.fieldOfView = Mathf.Clamp(cam.fieldOfView+1,20,60);
            targetFOV = defaultFOV;
            player.canMove--;
            zoom = false;
        }        

        if(dm.showingDialogue)
        {
            targetFOV = defaultFOV;
            cam.fieldOfView = targetFOV;
        }

        cam.fieldOfView = Mathf.Lerp(cam.fieldOfView,targetFOV,0.15f);
    }
}
