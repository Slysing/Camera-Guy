using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{

    public Transform itemLocation;
    public MeshRenderer itemRenderer;
    public MeshFilter itemMesh;
    public KeyCode interactButton;
    public KeyCode alternateInteractButton;
    public KeyCode exitButton;
    public KeyCode alternateExitButton;
    private Interactable currentInteractable;
    private Vector3 defaultPosition;
    public PlayerMovement controller;
    public TMPro.TextMeshProUGUI text;
    public float rotateSpeed=50;
    public GameObject backImage;

    // Layers
    public LayerMask layerMask;
    public Camera cam;
    void Start()
    {
        defaultPosition = itemLocation.localPosition;
        if (controller == null)
        controller = GetComponent<PlayerMovement>();
    }

    void Update()
    {
        if (currentInteractable == null)
        {
            if (Input.GetKeyDown(interactButton)|| Input.GetKeyDown(alternateInteractButton))
            {
                RaycastHit hit;
                Ray ray = cam.ScreenPointToRay(Input.mousePosition);

                if (Physics.Raycast(ray,out hit, 50,layerMask))
                {
                Debug.Log(hit.transform.name);
                    if (hit.transform.CompareTag("interactable"))
                    {
                        currentInteractable = hit.transform.GetComponent<Interactable>();

                        if (currentInteractable != null)
                        {
                            itemLocation.localPosition = defaultPosition + currentInteractable.positionOffset;

                            itemLocation.localRotation = Quaternion.Euler(currentInteractable.rotationOffset);
                            
                            itemRenderer.enabled = true;
                            currentInteractable.meshRenderer.enabled = false;
                  //          controller.enabled = false;
                            itemMesh.mesh = currentInteractable.meshFilter.mesh;
                            itemRenderer.materials = currentInteractable.meshRenderer.materials;
                            text.text = currentInteractable.message;
                            if  (currentInteractable.message != "")
                            {
                                backImage.SetActive(true);
                            }
                        }
                    }
                
                     else if (hit.transform.CompareTag("activate"))
                     {
                         InteractEvent currentEvent = hit.transform.GetComponent<InteractEvent>();
                         if (currentEvent != null)
                         {
                             currentEvent.Run();
                         }
                     }    
                }
            }

        }
        else
        {
            if (Input.GetKeyDown(exitButton)|| Input.GetKeyDown(alternateExitButton))
            {
                itemRenderer.enabled = false;
                controller.enabled = true;
                currentInteractable.meshRenderer.enabled = true;
                currentInteractable = null;
                text.text = "";
                backImage.SetActive(false);
            }  

            if (currentInteractable.canTurn)
            {
                Vector3 rotate = new Vector3 (0,Input.GetAxis("Mouse X"),Input.GetAxis("Mouse Y"));
                rotate *= rotateSpeed *Time.deltaTime;
                itemLocation.Rotate(rotate);
                Debug.Log ("yeah it rotates");
            }          
        }
        
    }
}
