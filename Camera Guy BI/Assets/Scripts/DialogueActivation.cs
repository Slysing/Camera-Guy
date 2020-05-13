using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueActivation : MonoBehaviour
{
    public DialogueManager dm;
    public float maxRayDistance;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && !dm.showingDialogue && Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out RaycastHit hit, maxRayDistance, 1 << 10))

        {
            dm.sceneName = hit.transform.name;

            if (Resources.Load<TextAsset>($"Dialogue/{dm.sceneName}") == null)
            {
                return;
            }
            dm.FadeInCanvas();
        }
    }
}
