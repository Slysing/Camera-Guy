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
    public bool pauseDialogue = false;

    public GameObject wallBreak;
    private Animator wallBreakAnimator;
    public AnimationClip wallBreakAnimation;
    private float smallPause;
    public AudioSource revSoundSource;

    public GameObject originalGangsters;
    public GameObject wallStable;
    public GameObject wallCrumble;

    private DialogueManager dm;

    public GameObject cashier;

    //Milk Hoarding
    public GameObject shelfMilks;
    public GameObject[] hoardMilks;
    public bool milkHoard = false;

    //crash leave anim
    public bool crashLeave = false;
    public AnimationClip crashLeaveAnim;


    //Karate Chop
    //[HideInInspector]
    public bool chopEnabled = false;

    // Start is called before the first frame update
    void Awake()
    {
        faceMemory = faceIndex;
        wallBreakAnimator = wallBreak.GetComponent<Animator>();
        dm = FindObjectOfType<DialogueManager>();
        smallPause = wallBreakAnimation.length;

        #region Correct state enforcer
        //just making sure these gameobjects are for sure in the correct states
        shelfMilks.SetActive(true);
        foreach (GameObject milkObject in hoardMilks)
        {
            milkObject.SetActive(false);
        }

        wallStable.SetActive(true);
        wallCrumble.SetActive(false);

        wallBreak.SetActive(false);

        originalGangsters.SetActive(true);
        #endregion

    }

    // Update is called once per frame
    void Update()
    {
        if(faceIndex != faceMemory)
        {
            faceMemory = faceIndex;
            //Debug.Log(faceIndex);
            emojihorrorFace.materials[1].SetTexture("_EmojiFace", faces[faceIndex]);
        }

        if(revSet)
        {
            revSet = false;
            StartCoroutine(WaitForRev(revTimeSet, smallPause));
            pauseDialogue = true;
            revSoundSource.PlayOneShot(revSoundSource.clip);
        }

        if (milkHoard)
        {
            milkHoard = false;
            shelfMilks.SetActive(false);
            foreach(GameObject milkObject in hoardMilks)
            {
                milkObject.SetActive(true);
            }
        }

        if(crashLeave)
        {
            crashLeave = false;
            pauseDialogue = true;
            wallBreakAnimator.SetBool("Leave", true);
            StartCoroutine(WaitForAnimation(crashLeaveAnim));
        }
    }

    IEnumerator WaitForRev(float timeToWait, float smallPause)
    {
        yield return new WaitForSeconds(timeToWait);

        //switch wall sections from stable to crumbly.
        wallStable.SetActive(false);
        wallCrumble.SetActive(true);

        //enable the motorbikes and start the animation
        wallBreak.SetActive(true);
        wallBreakAnimator.SetBool("Crash", true);

        //disable the old gangsters.
        originalGangsters.SetActive(false);

        //wait for the animation to finish before advancing the text
        yield return new WaitForSeconds(smallPause);
        pauseDialogue = false;
        dm.LoadNewLine();
    }

    IEnumerator WaitForAnimation(AnimationClip currentClip)
    {
        //wait for the animation to finish before advancing the text
        var waitTime = currentClip.length;
        yield return new WaitForSeconds(waitTime);
        pauseDialogue = false;
        dm.LoadNewLine();

        if (currentClip == crashLeaveAnim)
        {
            wallBreak.SetActive(false);
        }

        cashier.name = "cashier_03";
    }
}
