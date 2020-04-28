using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mouseCursor : MonoBehaviour
{
    public Camera cam;
    private SpriteRenderer rend;
    public Sprite handCursor;
    public Sprite normalCursor;
    void Update()
    {
        Vector3 cursorPos = cam.ScreenToViewportPoint(Input.mousePosition);
        transform.position = cursorPos;

        if (Input.GetMouseButtonDown(0))
        {
            rend.sprite = handCursor;
        }
            else if (Input.GetMouseButtonDown(0))
        {
            rend.sprite = normalCursor;
        }
        
    }
}
