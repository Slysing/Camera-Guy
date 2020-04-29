using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Death : MonoBehaviour {
public Transform spawnPoint;

 public void OnTriggerEnter(Collider other)
  {
        // detects if the player interacts 
	  if (other.transform.CompareTag("Player"))
	  {
            // teleports the player to the location
		  other.transform.position = spawnPoint.position;
	  }
  }
}
