using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Audio_Player : MonoBehaviour
{
    // Start is called before the first frame update

    AudioSource ac;
    void Start()
    {
        ac = GetComponent<AudioSource>();
    }




    // Disgarded code, not used in final
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
    {
        ac.PlayOneShot(ac.clip);
    }
        }
    }
}