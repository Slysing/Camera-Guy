using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : SingletonBase<AudioManager>
{
    AudioSource source;
    public AudioClip wreckIT;
    // Start is called before the first frame update
    void Start()
    {
        source = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void WreckIT()
    {
        if (!source.isPlaying)
        {
            source.clip = wreckIT;
            source.Play();
        }
    }
}
