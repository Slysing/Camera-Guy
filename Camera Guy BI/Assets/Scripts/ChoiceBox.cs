using UnityEngine;

public class ChoiceBox : MonoBehaviour
{
    public DialogueManager dm;
    public ChoiceButton[] choices;

    public CanvasGroup canvasGroup;

    private void OnValidate()
    {
        dm = FindObjectOfType<DialogueManager>();
        canvasGroup = GetComponent<CanvasGroup>();
    }
}
