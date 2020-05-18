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

    //Rev time
    public float revTimeSet;
    [HideInInspector]
    public bool revSet = false;
    [HideInInspector]
    public bool pauseDialogue = false;
    public GameObject wallBreak;
    private Animator wallBreakAnimator;

    //Karate Chop
    //[HideInInspector]
    public bool chopEnabled = false;

    // Start is called before the first frame update
    void Awake()
    {
        faceMemory = faceIndex;
        wallBreakAnimator = wallBreak.GetComponent<Animator>();
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

        if(revSet)
        {
            revSet = false;
            StartCoroutine(WaitForTime(revTimeSet));
        }
    }

    IEnumerator WaitForTime(float timeToWait)
    {
        yield return new WaitForSeconds(timeToWait);
        wallBreak.SetActive(true);
        wallBreakAnimator.SetBool("Crash", true);
    }
}
