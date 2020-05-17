using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventManager : MonoBehaviour
{
    //face stuff
    public int faceIndex = 0;
    private int faceMemory;
    public Texture[] faces;
    public Renderer emojihorrorFace;

    // Start is called before the first frame update
    void Awake()
    {
        faceMemory = faceIndex;
    }

    // Update is called once per frame
    void Update()
    {
        if(faceIndex != faceMemory)
        {
            faceMemory = faceIndex;
            Debug.Log(faceIndex);
            emojihorrorFace.materials[1].SetTexture("_EmojiFace", faces[faceIndex]);
        }
    }
}
