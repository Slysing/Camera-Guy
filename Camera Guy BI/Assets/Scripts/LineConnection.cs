using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineConnection : MonoBehaviour
{

    LineRenderer line;

    public Transform transform1;
    public Transform transform2;

    // Start is called before the first frame update
    void Start()
    {
        line = GetComponent<LineRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        line.SetPosition(0, transform1.position);
        line.SetPosition(1, transform2.position);
    }
}
