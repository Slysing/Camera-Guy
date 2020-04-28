using UnityEngine;

/// <summary>
/// Declares classes like this.
/// public class MyClass : SingletonBase<MyClass>
/// {
/// 
/// }
/// </summary>
/// <typeparam name="T"></typeparam>
public class SingletonBase<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T singleton;

    public static T Instance
    {
        get
        {
            if (singleton == null)
            {
                singleton = GameObject.FindObjectOfType<T>();
                if (singleton == null)
                {
                    Debug.LogError("An instance of " + typeof(T) + " is needed in the scene, but there is none.");
                }
            }
            return singleton;
        }
    }
	
}
