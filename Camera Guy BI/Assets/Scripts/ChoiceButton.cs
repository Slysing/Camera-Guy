using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ChoiceButton : MonoBehaviour
{
    public Button button;
    public TextMeshProUGUI text;
    public string scene;
    public DialogueManager dm;

    ChoiceBox choiceBox;

    private void Awake()
    {
        choiceBox = FindObjectOfType<ChoiceBox>();
        button = GetComponent<Button>();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }

    [ContextMenu("Test")]

    public void Update()
    {
     if(Input.GetKeyDown(KeyCode.E) && dm.choiceBoxActive)
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
        button.image.color = newColour;
    }
    public void SetSprite(Sprite newSprite)
    {
        button.image.sprite = newSprite;
    }
}
