using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FakeQuest : AnimationController {

	public string checkCode;
	public int amount;
	public override void Run()
	{
        // links an object to another seting a flag system to be able to activate another script once the player interacts with it the first object
		if (PlayerPrefs.GetInt(checkCode) >= amount )
		{
			eventToDo.Invoke ();

		}
	}
}
