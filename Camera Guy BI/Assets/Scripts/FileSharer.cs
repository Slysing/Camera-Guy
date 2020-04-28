using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

[System.Serializable]
public class TransferFile
{
    public int number;
    public bool flag;
    public string text;
}

public class FileSharer : MonoBehaviour
{
    public TransferFile file;
    readonly string fileName = "ProjectDragon";
    string path;

    void Start()
    {
        if (string.IsNullOrWhiteSpace(fileName)) // Throws an error if the file is empty. Shouldn't happen unless code is changed
        {
            throw new System.Exception("File Name is Empty! Please provide a file name");
        }

        path = Application.persistentDataPath.Substring(0, Application.persistentDataPath.LastIndexOf(Application.productName)) + fileName + ".json"; // Generates the string representation of where the file should be
        if (!File.Exists(path)) // Creates the file if it doesn't already exist
            File.Create(path);
    }

    /// <summary>
    /// Saves the file out to a designated place
    /// </summary>
    [ContextMenu("Save File")]
    void SaveFile()
    {
        string json = JsonUtility.ToJson(file); // Converts the class to a json string
        File.WriteAllText(path, json); // Saves the string as a json file
    }

    /// <summary>
    /// Reads the file from a designated place
    /// </summary>
    [ContextMenu("Read File")]
    void ReadFile()
    {
        string json = File.ReadAllText(path); // Gets the json file and converts it to a string
        file = (TransferFile)JsonUtility.FromJson(json, typeof(TransferFile)); // Converts the json string back into a class. Discards anything not declared in the class
    }
}

