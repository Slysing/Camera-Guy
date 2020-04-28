using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Management : MonoBehaviour
{
    void Start()
    {

    }

    void Update()
    {

    }
    public void StartGame()
    {
        // links to the buttons allowing the level to change to the game
        SceneManager.LoadScene(1);
    }
    public void ExitGame()
    {
        //  Closes the game
        Application.Quit();
    }
}

