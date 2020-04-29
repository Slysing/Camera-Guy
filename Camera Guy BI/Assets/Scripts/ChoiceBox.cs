using UnityEngine;

public class ChoiceBox : MonoBehaviour
{
    public DialogueManager dm;
    public ChoiceButton[] choices;
    public int optionNumber;
    public int selectedOption;

    public KeyCode downButton;
    public KeyCode upButton;

    public CanvasGroup canvasGroup;

    private void Awake()
    {
        downButton = KeyCode.S;
        upButton = KeyCode.W;
    }

    private void OnValidate()
    {
        dm = FindObjectOfType<DialogueManager>();
        canvasGroup = GetComponent<CanvasGroup>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(upButton) && selectedOption != 0)
        {
            selectedOption--;
        }

        if (Input.GetKeyDown(downButton) && selectedOption != optionNumber-1)
        {
            selectedOption++;
        }

        if(Input.GetKeyDown(KeyCode.J))
        {
            Debug.Log(selectedOption);
            Debug.Log(optionNumber);
        }
    }
}
