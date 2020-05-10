using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueActivation : MonoBehaviour
{
    public DialogueManager dm;
    public float maxRayDistance;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out RaycastHit hit, maxRayDistance, 1 << 10))
        {
            dm.LoadSceneTextFile(hit.transform.name);
            dm.LoadNewLine();
            Debug.Log(hit.transform.name);
        }
    }
}
