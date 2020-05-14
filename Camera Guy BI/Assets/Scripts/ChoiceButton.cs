using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ChoiceButton : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI text;
    public string scene;
    public DialogueManager dm;

    ChoiceBox choiceBox;

    private void Awake()
    {
        choiceBox = FindObjectOfType<ChoiceBox>();
        image = GetComponent<Image>();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }

    [ContextMenu("Test")]

    public void Update()
    {
     if(Input.GetKeyDown(dm.advanceButton) && dm.choiceBoxActive)
        {
            OnSelect();
        } 
    }
    public void OnSelect()
    {
        if(choiceBox.choices[choiceBox.selectedOption].gameObject == gameObject)
        {
            choiceBox.dm.choiceBoxActive = false;
            choiceBox.canvasGroup.alpha = 0;
            choiceBox.canvasGroup.interactable = choiceBox.canvasGroup.blocksRaycasts = (choiceBox.canvasGroup.alpha == 1);
            choiceBox.dm.LoadSceneTextFile(scene);
            choiceBox.dm.LoadNewLine();
        }
    }


    public void SetColour(Color newColour)
    {
        image.color = newColour;
    }
    public void SetSprite(Sprite newSprite)
    {
        image.sprite = newSprite;
    }
}
