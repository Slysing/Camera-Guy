using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ChoiceButton : MonoBehaviour
{
    public Button button;
    public TextMeshProUGUI text;
    public string scene;

    ChoiceBox choiceBox;

    private void OnValidate()
    {
        choiceBox = FindObjectOfType<ChoiceBox>();
        button = GetComponent<Button>();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }

    [ContextMenu("Test")]
    public void OnClick()
    {
        choiceBox.dm.choiceBoxActive = false;
        choiceBox.canvasGroup.alpha = 0;
        choiceBox.canvasGroup.interactable = choiceBox.canvasGroup.blocksRaycasts = (choiceBox.canvasGroup.alpha == 1);
        choiceBox.dm.LoadSceneTextFile(scene);
        choiceBox.dm.LoadNewLine();
    }
}
