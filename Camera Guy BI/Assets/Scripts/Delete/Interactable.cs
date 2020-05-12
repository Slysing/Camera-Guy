using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interactable : MonoBehaviour
{
    public MeshRenderer meshRenderer;
    public MeshFilter meshFilter;
    public Vector3 positionOffset;
    public Vector3 rotationOffset; 
    public string message; 
    public bool canTurn;
    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();   
        meshFilter = GetComponent<MeshFilter>();           
           }
}
