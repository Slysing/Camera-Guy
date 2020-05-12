using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;

public class ChoiceBox : MonoBehaviour
{
    public DialogueManager dm;
    public ChoiceButton[] choices;
    public int optionNumber;
    public int selectedOption;

    public KeyCode downButton;
    public KeyCode upButton;

    public Color defaultColour;
    public Color selectedColour;

    public Sprite defaultSprite;
    public Sprite selectedSprite;


    public CanvasGroup canvasGroup;

    private void Awake()
    {
        downButton = KeyCode.S;
        upButton = KeyCode.W;
        ColorChange();
        SpriteChange();
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
            SpriteChange();
        }

        if (Input.GetKeyDown(downButton) && selectedOption != optionNumber-1)
        {
            selectedOption++;
            ColorChange();
            SpriteChange();
        } 
    }
    private void SpriteChange()
    {
        for (int i = 0; i < choices.Length; i++)
        {
            if (i == selectedOption)
            {
                choices[i].SetSprite(selectedSprite);
            }
            else
            {
                choices[i].SetSprite(defaultSprite);
            }
        }
    }
    private void ColorChange()
    {
        if (selectedSprite == null || defaultSprite == null)
            return;

        for (int i = 0; i < choices.Length; i++)
        {
            if (i == selectedOption)
            {
                choices[i].SetColour(selectedColour);
            }
            else
            {
                choices[i].SetColour(defaultColour);
            }
        }


        //foreach (ChoiceButton buttonScript in choices)
        //{
        //    if(buttonScript == choices[selectedOption])
        //    {
        //        buttonScript.gameObject.GetComponent<Button>();
        //    }
        //}
    }
}
