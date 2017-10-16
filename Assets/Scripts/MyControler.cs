using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyControler : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Escape))
			Application.Quit();
		if (ApplicationModel.on_tracking_found == 1)
		{
			Debug.Log("My tracking is detecting");
			StartCoroutine(WWWValue());
			ApplicationModel.on_tracking_found = 0;
		}
	}


	public static bool IsInternetConnection()
	{
		bool isConnectedToInternet = false;
		if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork ||
		   Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
		{
			isConnectedToInternet = true;
		}
		return isConnectedToInternet;
	}

	IEnumerator WWWValue()
	{
		if (IsInternetConnection())
		{
			Debug.Log("Connection is avelible");
			string URLx = "http://www.tatidea.com/ARTest/php/update_table.php5";

			WWW www_db = new WWW(URLx);
			yield return www_db;
			Debug.Log(www_db.text);
		}
		else { Debug.Log("Connection is not avelible"); }
	}
}
