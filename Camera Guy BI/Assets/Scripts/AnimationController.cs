using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationController : MonoBehaviour 
{

public UnityEngine.Events.UnityEvent eventToDo;
	
public virtual void Run()
	{
        // creates a chart with multiple functions to reduce the amount of coding clutter
eventToDo.Invoke();
	}


    // allows the EventToDo.Invoke to implement audio per click, allowing repeated interactions 
	public void PlaySound(AudioClip audioClicker)
	{
		AudioSource source = GetComponent<AudioSource>();

	if (source != null)
	{
		source.PlayOneShot(audioClicker);
	}
	}
	public void SetPref(string code)
	{
		PlayerPrefs.SetInt(code,1);
	}
}
