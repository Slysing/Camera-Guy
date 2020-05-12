using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractEvent : MonoBehaviour
{

public UnityEngine.Events.UnityEvent turnOn;
public UnityEngine.Events.UnityEvent turnOff;
public bool isOn;	
public	void Run()
	{
        if (isOn)
        {
            turnOff.Invoke();
        }
        else 
        {
            turnOn.Invoke();
        }
            isOn = !isOn; 
	}
}

