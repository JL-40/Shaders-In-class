using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    [SerializeField] Text pauseText;
    [SerializeField] int score = 0;

    [SerializeField] Text restartText;

    [SerializeField] ParticleSystem deathParticles;
    [SerializeField] float delay;
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        Instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        pauseText.gameObject.SetActive(false);
        restartText.gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        Quit();

        Unpause();

        if (score == 4)
            Win();

        if (Input.GetKeyDown(KeyCode.R) && restartText.gameObject.activeSelf == true)
        {
            RestartGame();
        }
    }

    public void Score()
    {
        score++;
    }

    public void Win()
    {
        if (pauseText.gameObject.activeSelf == false)
        {
            pauseText.gameObject.SetActive(true);

            //EndGame();
            DelayedEndGame();
        }
    }

    public void EndGame()
    {
        Time.timeScale = 0f;
        Debug.Log($"Press 'Escape' to Quit.");

        if (restartText.gameObject.activeSelf == false)
        {
            restartText.gameObject.SetActive(true);
        }
    }

    // Exit play
    public void Quit()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
#if UNITY_EDITOR
            EditorApplication.ExitPlaymode();
#else
            Application.Quit();
#endif
        }
    }

    public void Unpause()
    {
        if (Input.GetKeyDown(KeyCode.P) && Time.timeScale == 0f)
        {
            score *= -1; // inverse score to unpause.

            if (pauseText.gameObject.activeSelf == false)
            {
                pauseText.gameObject.SetActive(true);
            }

            Time.timeScale = 1f;
        }
    }

    public void PlayDeathVFX(Transform origin)
    {
        ParticleSystem newVFX = Instantiate(deathParticles);
        newVFX.transform.position = origin.position;        
        Destroy(newVFX);
    }

    public void DelayedEndGame()
    {
        StartCoroutine(DelayEndGame());
    }
    IEnumerator DelayEndGame()
    {
        yield return new WaitForSeconds(delay);
        EndGame();
    }

    public void RestartGame()
    {
        SceneManager.LoadScene("SampleScene");
        Time.timeScale = 1f;
    }
}
