using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

public class GVRButton : MonoBehaviour
{
    public Image GVRImage;
    public UnityEvent GVRClick;
    public bool GVRStatus;
    public float TotalTime = 2;
    public float GVRTimer;
    // Update is called once per frame
    void Update()
    {
        if (GVRStatus)
        {
            GVRTimer += Time.deltaTime;
            //GVRImage.fillAmount += GVRTimer / TotalTime ;
            GVRImage.fillAmount += 0.01f;
        }
        if (GVRTimer > TotalTime)
        {
            GVRClick.Invoke();
        }
    }

    public void GVROn()
    {
        GVRStatus = true;
    }

    public void GVROff()
    {
        GVRStatus = false;
        GVRTimer = 0;
        GVRImage.fillAmount = 0;
    }
}
