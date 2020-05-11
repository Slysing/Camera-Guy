using UnityEngine;
using UnityEngine.UIElements;

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
            ColorChange();
        }

        if (Input.GetKeyDown(downButton) && selectedOption != optionNumber-1)
        {
            selectedOption++;
            ColorChange();
        } 
    }

    private void ColorChange()
    {
        foreach (ChoiceButton buttonScript in choices)
        {
            if(buttonScript == choices[selectedOption])
            {
                buttonScript.gameObject.GetComponent<Button>()
            }
        }
    }
}
