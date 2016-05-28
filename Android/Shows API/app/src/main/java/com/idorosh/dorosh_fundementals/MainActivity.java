package com.idorosh.dorosh_fundementals;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity{



    //Progress bar for showing that the data is being downloaded
    ProgressBar pb;

    //Array that stores the data from the Info custom class
    ArrayList<Info> apiInfo = new ArrayList<>();
    String jsonString;

    List<Info> testing = new ArrayList<>();

    //Sets default tag when the app first loads
    String searchFieldText = "the last ship";

    //SharedPreferences to detect if its the first time that the app is running.
    SharedPreferences prefs = null;

    WriteAndRead saved = new WriteAndRead();
    String finalString;

    //Array to hold image urls
    final ArrayList<String> images = new ArrayList<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Setting the fragment as the view
        setContentView(R.layout.fragment_layout);



        //Setting preference when app runs
        prefs = getSharedPreferences("com.idorosh.dorosh_fundementals", MODE_PRIVATE);

        //Sets the progress bar to invisible when the app loads
        pb = (ProgressBar) findViewById(R.id.progressBar1);
        pb.setVisibility(View.INVISIBLE);

        //Checking network on run
        if(!checkNetwork()){
            Toast.makeText(MainActivity.this, "Network isn't Available", Toast.LENGTH_SHORT).show();
        }



        //Sets search button variable based on orientation
        if (getResources().getConfiguration().orientation
                == Configuration.ORIENTATION_PORTRAIT) {
            View myButton = findViewById(R.id.showPrefs);
            myButton.setOnClickListener(showSettings);
        }
        requestData("");


        test = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);


        //Was planning on using this to get api data on all string in my created xml array.
        /*String[] tvShows = getResources().getStringArray(R.array.shows);
        for(int i =0; i < tvShows.length; i++)
        {
            listItem(tvShows[i]);
        }
        */
    }

    private View.OnClickListener showSettings = new View.OnClickListener() {

        @Override
        public void onClick(View v) {

            Intent photoView = new Intent(getApplicationContext(), SettingsActivity.class);
            startActivity(photoView);

        }
    };



    //Displays alert dialog if its the first run.
    @Override
    protected void onResume() {
        super.onResume();

        if (prefs.getBoolean("firstrun", true)) {
            if(!checkNetwork()){
                new AlertDialog.Builder(MainActivity.this)
                        .setTitle("First Run")
                        .setMessage("Please Connect to network first")
                        .setCancelable(false)
                        .setPositiveButton("ok", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        }).create().show();
            }
            prefs.edit().putBoolean("firstrun", false).commit();
        }
    }






    public void showCurrent(int Index){
        DisplayItems(testing, Index);
    }



    ConnectivityManager test;
    //Checking for network and returning true or false.
    public boolean checkNetwork()
    {


        ConnectivityManager mgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo netInfo = mgr.getActiveNetworkInfo();

        if(netInfo != null && netInfo.isConnectedOrConnecting()) {
            return true;
        } else {
            return false;
        }
    }


    public void getDataInformation(String currentSearch){
        requestData(currentSearch);
    }

    public void pullData(URL url){
        new GetData().execute(url);
    }



    //Requesting data with a url that excepts either a selected show from the list or text that was requested by the user
    private void requestData(String tagText) {
        //Clears Info array
        apiInfo.clear();
        //Url that excepts tag from tagText
        String finalShow =  tagText.replace(' ', '+');
        String testString = "iphones";
        String urlString = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q={"+testString+"}";
        URL url = null;

        try {
            url = new URL(urlString);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        new GetData().execute(url);
    }




    //Getting data with an Async Task
    private class GetData extends AsyncTask<URL, String, JSONArray> {
        @Override
        protected void onPreExecute() {
            pb.setVisibility(View.VISIBLE);

        }

        @Override
        protected JSONArray doInBackground(URL... urls) {
            JSONObject apiData;
            String allShows = "";

            //Checking network again
            if (checkNetwork()) {
                //Stores data from the api
                jsonString = "";

                //Connects to url and saves the json information to json strings
                for (URL queryURL : urls) {
                    try {
                        URLConnection connection = queryURL.openConnection();
                        jsonString = IOUtils.toString(connection.getInputStream());

                        break;
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }


            JSONArray apiArray = null;
            JSONObject apiData2;

            //Sets apiData JSONObject using the jsonString
            try {
                apiData = new JSONObject(jsonString);
            } catch (JSONException e) {
                e.printStackTrace();
                apiData = null;
            }

            //Gets photos object from the JSONObject
            try {
                apiData2 = apiData.getJSONObject("responseData");
            } catch (JSONException e) {
                e.printStackTrace();
                apiData2 = null;
            }

            try {
                assert apiData != null;
                apiArray = apiData2.getJSONArray("results");
            } catch (JSONException e) {
                e.printStackTrace();
            }



            return apiArray;
        }

        @Override
        protected void onPostExecute(JSONArray jsonArray) {


            //Setting Object from JSON Array
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject childJSONObject = null;
                try {
                    childJSONObject = jsonArray.getJSONObject(i);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                try {
                    //Creating new objects in custom class using the information in the JSON object from childJSONObject
                    apiInfo.add(new Info(childJSONObject.getString("titleNoFormatting"), childJSONObject.getString("publisher"), childJSONObject.getString("publishedDate"), childJSONObject.getString("unescapedUrl")));


                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            try {
                saveFile(apiInfo);
            } catch (IOException e) {
                e.printStackTrace();
            }

            try {
                readFile();
            } catch (IOException e) {
                e.printStackTrace();
            }


            //gets image urls
            for(int i =0; i < testing.size(); i++)
            {
                String img = testing.get(i).getmTitle();

            }




            //gets image urls
            for(int i =0; i < testing.size(); i++)
            {
                String img = testing.get(i).getmTitle();
                images.add(img);

            }

            System.out.println(images);
            pb.setVisibility(View.INVISIBLE);


        }
    }

    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("test.dat", MODE_PRIVATE);

        saved.createFile(fos, info);
        return null;
    }


    public String readFile() throws IOException {
        FileInputStream fin = openFileInput("test.dat");
        testing = saved.readFile(fin);
        System.out.println(testing.get(0).getmTitle());
        return "hello";
    }

    //Method to update text views
    public void DisplayItems(List<Info> testing, int currentIndex){

        TextView text1 = (TextView) findViewById(R.id.title);
        text1.setText(testing.get(currentIndex).getmTitle().toString());

        TextView text2 = (TextView) findViewById(R.id.genre);
        text2.setText(testing.get(currentIndex).getmGenre().toString());

        TextView text3 = (TextView) findViewById(R.id.year);
        text3.setText(testing.get(currentIndex).getmYear().toString());

        TextView text4 = (TextView) findViewById(R.id.plot);
        text4.setText(testing.get(currentIndex).getmPlot().toString());


    }

    public interface Interface {
        //CONSTANT DECLARATIONS
        public final String INTERFACETAG = "RULES";
        //METHOD SIGNATURES
        public void doSomething(String input);
    }

}
