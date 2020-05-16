using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallCrumble : MonoBehaviour
{

    private void Start()
    {
        Crumble();
    }

    public void Crumble()
    {
        Vector3 offset = new Vector3(-1.123f, 2.911f, -1.501f);
        Vector3 brickScale = new Vector3(0.75f, 0.35f, 0.37f);

        bool largeRow = false;

        float xOffset = 0.758f;
        float yOffset = -0.361f;

        for (int i = 0; i < 8; ++i)
        {
            // Short way to do if/else
            int columnSize = largeRow ? 5 : 4;
            float halfStep = largeRow ? 0.379f : 0f;// : 0.379f;
            for (int j = 0; j < columnSize; ++j)
            {
                GameObject brick = GameObject.CreatePrimitive(PrimitiveType.Cube);
                brick.transform.SetParent(transform);

                brick.transform.localRotation = Quaternion.identity;
                brick.transform.localScale = brickScale;



                Vector3 brickPos = new Vector3(j * xOffset - halfStep, i * yOffset,0);
                brick.transform.localPosition = brickPos+offset;

           //  -3  8.315   2.25




            }
            largeRow = !largeRow;
        }
    }

}
