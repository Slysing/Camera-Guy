using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Camera_Switch : MonoBehaviour
{
    [System.Serializable]
    public class CameraPosition
    {
        public string location;
        public Vector3 position;
        public Vector3 rotation;
    }


    public GameObject mainCamera;
    public GameObject movingCam;

    public CameraPosition [] locations;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SetCameraLocation("foyer");
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            ResetCamera( );
        }

    }






    public void ResetCamera()
    {
        mainCamera.SetActive(true);
        movingCam.SetActive(false);
    }


    public void SetCameraLocation (string input)
    {
        for (int i = 0; i < locations.Length; i++)
        {
            if (locations[i].location.ToLower() == input.ToLower())
            {
                movingCam.transform.position = locations[i].position;
                movingCam.transform.rotation = Quaternion.Euler(locations[i].rotation);
                
                
                
                
                mainCamera.SetActive(false);
                movingCam.SetActive(true);

            }

        }


    }

    





//  public GameObject[] camController;


//   private void Start()
//  {
        //   camController[0].SetActive(true);
//       SetCamera(0);
//   }

//    public void SetCamera(int num)
//   {
//        if (num < camController.Length)
//       {
//        for (int i = 0; i < camController.Length;i++)
//          {
//                if (i == num)
//{ camController[i].SetActive(true);
//  }
//    else
//      {
//                  camController[i].SetActive(false);
//        }




//      }
//    }
//  }
    







}

//   public GameObject mainCam;
//    public GameObject milkBar;
//   public GameObject foyer;

//    public void SetMilkBar()
//   {
//    milkBar.SetActive(true);
//        foyer.SetActive(false);
//    mainCam.SetActive(false);
//}
//public void SetFoyer()
//    {
//        milkBar.SetActive(false);
//        foyer.SetActive(true);
//        mainCam.SetActive(false);
//    }
//        public void SetMaincam()
//   {
//        milkBar.SetActive(false);
//        foyer.SetActive(false);
//        mainCam.SetActive(true);
//    }

//}
