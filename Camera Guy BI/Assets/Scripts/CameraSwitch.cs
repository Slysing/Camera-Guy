using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwitch : MonoBehaviour
{
    public Camera[] cameraArray;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SetCamera(1);
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            SetCamera(0);
        }
    }

    public void SetCamera(int input)
    {
        for (int i = 0; i < cameraArray.Length; i++)
        {
            if (cameraArray[input] == cameraArray[i])
            {
                cameraArray[i].enabled = true;
            }
            else
            {
                cameraArray[i].enabled = false;
            }
        }
    }
}
